Alfred::App.controllers :api do

  before do
    halt 403 unless request.env['HTTP_API_KEY'] == 'my_secret_key'
  end

  get :next_task do
  	Solution.first(:test_result => 'not_available')
    content_type :json
    {  :id => solution.id,
    	 :test_file_path => solution.assignment.file_path,
    	 :solution_file_path => solution.file_path,
    	 :test_script => solution.assignment.test_script
    }.to_json
  end

end
