require 'spec_helper'

describe "MyController" do
  let(:current_account) { Account.new(name: 'Jane', surname: 'Doe', buid: '1234', role: 'student', tag: 'mie') }

  before (:each) do
    Alfred::App.any_instance.stub(:current_account).and_return(current_account)
    # Alfred::App.any_instance.stub(:current_course)
    #   .and_return(Factories::Course.algorithm)
  end

  describe "get profile" do

    it "should render profile view" do
      Alfred::App.any_instance.should_receive(:render).with('my/profile')

      get "/my/profile"

      last_response.should be_ok
    end
  end

  describe 'update profile' do
    let(:updated_name) { 'Johnny' }
    let(:updated_surname) { 'Be Good' }
    let(:updated_tag) { 'vie' }
    let(:updated_password) { 'new+password' }

    it "should update fields without modifying password" do
      current_account.should_receive(:update).with({ 'name' => updated_name, 'surname' => updated_surname, 'tag' => updated_tag }).and_return(true)

      put '/my/profile', account: { name: updated_name, surname: updated_surname, tag: updated_tag, password: '', password_confirmation: '' }
    end

    it "should update fields and password" do
      current_account.should_receive(:update).with({ 'name' => updated_name, 'surname' => updated_surname, 'tag' => updated_tag, 'password' => updated_password, 'password_confirmation' => updated_password }).and_return(true)

      put '/my/profile', account: { name: updated_name, surname: updated_surname, tag: updated_tag, password: updated_password, password_confirmation: updated_password }
    end
  end

  describe 'enroll' do 

    it 'should enroll the current_account in the active course' do
      course = Course.new
      Course.should_receive(:active).and_return(course)
      current_account.should_receive(:enroll).with(course)
      Alfred::App.any_instance.should_receive(:render).with('home/index')
      
      put '/my/enroll'

    end    
  end

end
