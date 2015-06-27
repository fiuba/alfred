require 'spec_helper'

# It is not a real controller.  It spec files encapsulates a variety of
# tests for app resourses
#
describe "AppController" do
  let(:student_name)      { 'Carles' }
  let(:student_surname)   { 'Darwin' }
  let(:student_buid)      { '00001' }
  let(:student_email)     { 'charlesdarwin@student.com' }
  let(:student_tag)       { '' }
  let(:student_pass)      { 'foobar' }
  let(:course)            { Factories::Course.algorithm }

  describe "register" do
    before do
      @new_student = {
        :account => {
          :name => student_name,
          :surname => student_surname,
          :buid => student_buid,
          :email => student_email,
          :password => student_pass,
          :password_confirmation => student_pass
        }
      }
      Course.stub(:active).and_return(course)
    end

    describe "student registers himself with a valid tag" do
      before do
        @new_student[:account][:tag] = Account.valid_tags.first
      end

      it "should create a new student" do
        post "/register", @new_student

        Account.all.size.should > 0

        new = Account.all.last
        new.is_student?.should == true
        new.name.should == student_name
        new.surname.should == student_surname
        new.buid.should == student_buid
        new.email.should == student_email
        new.tag.should == Account.valid_tags.first
      end
    end

    describe "student cannot register himself with an invalid tag" do
      before do
        @new_student[:account][:tag] = '<invalid tag>'
      end

      it "should not create a new student" do
        post "/register", @new_student

        Account.all.size.should == 0
      end
    end
  end

  describe "POST #restore_password" do

    context "invalid email" do

      it "should redirect to restore password" do
        post :restore_password, { account: {email: "invalid@email.com"} }

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to eq "http://example.org/restore_password"
      end

    end

    context "valid email" do

      let!(:account_password) { "123123123" }
      let!(:account_email) { "m.f.melendi@gmail.com" }
      let!(:account) { Account.create!(name: "Matias Melendi", email: account_email,
                                       password: account_password, password_confirmation: account_password) }

      it "should change the account password" do
        post :restore_password, { account: {email: account_email} }

        modified_account = Account.find_by_email(account_email)

        expect(modified_account.password).to_not eq account_password
      end

      it "should redirect to the login page" do
        post :restore_password, { account: {email: account_email} }

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to eq "http://example.org/login"
      end

    end

  end
end
