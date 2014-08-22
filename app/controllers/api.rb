Alfred::App.controllers :api do

  before do
    puts "request key: #{request.env['HTTP_API_KEY']}"
    puts "env key: #{ENV['API_KEY']}"
    #halt 403 unless request.env['HTTP_API_KEY'] == ENV['API_KEY']
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
    puts 'registering task_result'
    solution = Solution.get(params[:id]) 
    return if solution.nil?
    result = params[:test_result]
    output = params[:test_output]
    solution.register_test_result(result, output)
    solution.save
    deliver(:notification, :solution_test_result, solution) \
      unless MailNotifierConfig.has_to_prevent_notification_for( :test_result )
  end

  post :karma,:csrf_protection => false do
    puts 'registering karma'
    student = Account.find_by_buid(params[:buid])
    return 404 if student.nil?
    karma = Karma.for_student_in_course(student, Course.active)
    karma.description = params[:description]
    karma.save
  end 

end
