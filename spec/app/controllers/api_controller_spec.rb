require 'spec_helper'

describe "ApiController" do
  
  describe "next_task" do

    it "should return 200 even when there is no pending solutions" do
      ENV['API_KEY'] = 'my_secret_key'
      Solution.should_receive(:first).and_return(nil)
      get '/api/next_task', {}, 'HTTP_API_KEY' => 'my_secret_key'
      last_response.status.should == 200
    end

    it "should return 403 when api_key is not provided" do
      ENV['API_KEY'] = 'my_secret_key'
      get '/api/next_task'
      last_response.status.should == 403
    end

  end

end
