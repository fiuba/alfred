Alfred::App.controllers :api do

  before do
    halt 403 unless request.env['HTTP_API_KEY'] == ENV['API_KEY']
  end

  get :next_task do
  	solution = Solution.first(:test_result => 'not_available')
    return {}.to_json if solution.nil?
    test_script = solution.assignment.test_script.gsub('${buid}',solution.account.buid)
    content_type :json
    {
      :id => solution.id,
      :buid => solution.account.buid,
      :test_file_path => solution.assignment.assignment_file.path,
    	:solution_file_path => solution.solution_generic_files.first.path,
    	:test_script => test_script
    }.to_json
  end

  post :task_result,:csrf_protection => false do
    solution = Solution.get(params[:id]) 
    return if solution.nil?
    solution.test_result = params[:test_result]
    solution.test_output = params[:test_output]
    solution.save
    deliver(:notification, :solution_test_result, solution)  
  end

end