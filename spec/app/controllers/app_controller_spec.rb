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

  before (:each) do
    DataMapper.auto_migrate!
  end

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

end
