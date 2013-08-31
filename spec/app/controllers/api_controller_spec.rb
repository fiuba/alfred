require 'spec_helper'

describe "ApiController" do
  let(:secret_key_value) { 'do_not_tell_anybody' } 
  
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

  describe "task_result" do
    let(:assignment) { Factories::Assignment.vending_machine }
    let(:solution) { Factories::Solution.for( assignment ) }

    describe "email notification" do
      before  { ENV['API_KEY'] = secret_key_value }
      after   { ENV.delete('API_KEY') }

      it "should notify author about test result" do
        Alfred::App.any_instance.should_receive(:deliver)
        post '/api/task_result', 
          { :id => solution.id }, 
          { 'HTTP_API_KEY' => secret_key_value }
      end

      describe "turning off test_result notification for students" do
        before  { ENV['MAIL_PREVENT_NOTIFICATION_FOR'] = 'test_result' }
        after   { ENV.delete('MAIL_PREVENT_NOTIFICATION_FOR') }

        it "should not notify author about test result" do
          Alfred::App.any_instance.should_not_receive(:deliver)
          post '/api/task_result', 
            { :id => solution.id }, 
            { 'HTTP_API_KEY' => secret_key_value }
        end
      end
    end
  end

end
