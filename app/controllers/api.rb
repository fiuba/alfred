Alfred::App.controllers :api do

  before do
    halt 403 unless request.env['HTTP_API_KEY'] == ENV['API_KEY']
  end

  get :next_task do
  	solution = Solution.last # first(:test_result => 'not_available')
    content_type :json
    {  :id => solution.id,
    	 :test_file_path => solution.assignment.assignment_generic_files.first.path,
    	 :solution_file_path => solution.solution_generic_files.first.path,
    	 :test_script => solution.assignment.test_script
    }.to_json
  end

  post :task_result,:csrf_protection => false do
    solution = Solution.get(params[:id]) 
    solution.test_result = params[:test_result]
    solution.test_output = params[:test_output]
    solution.save
  end

end