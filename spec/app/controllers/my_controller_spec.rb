require 'spec_helper'

describe "MyController" do

  before (:each) do
    DataMapper.auto_migrate!

    Alfred::App.any_instance.stub(:current_account)
      .and_return(Factories::Account.student)
    Alfred::App.any_instance.stub(:current_course)
      .and_return(Factories::Course.algorithm)
  end

  describe "get profile" do

    it "should render profile view" do
      Alfred::App.any_instance.should_receive(:render)
        .with('my/profile')

      get "/my/profile"

      last_response.should be_ok
    end

  end

end
