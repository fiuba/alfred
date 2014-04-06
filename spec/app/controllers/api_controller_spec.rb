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

  describe "karma" do

    it "should return 404 when student not found" do
      ENV['API_KEY'] = secret_key_value
      post '/api/karma',
          { :buid => 'yerba' }, 
          { 'HTTP_API_KEY' => secret_key_value }
      last_response.status.should == 404
    end

    it "should create karma" do
      ENV['API_KEY'] = secret_key_value
      student = Account.new_student({:buid => '12345'}) 
      Account.should_receive(:find_by_buid).and_return(student)
      Course.should_receive(:active).and_return(Course.new)
      karma = Karma.new
      Karma.should_receive(:new).and_return(karma)
      karma.should_receive(:save)
      post '/api/karma',
          { :buid => student.buid, :value => 1, :description => 'good job!' }, 
          { 'HTTP_API_KEY' => secret_key_value }
      last_response.status.should == 200
      karma.value.should == 1
      karma.description.should == 'good job!'
    end

  end

end
