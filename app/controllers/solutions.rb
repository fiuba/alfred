Alfred::App.controllers :solutions do
	before do
    @assignment = Assignment.find_by_id( params[:assignment_id] )
	end	

	# for teacher only
  get :index, :map => '/assignments/:assignment_id/students/:student_id/solutions'  do
  	@student = Account.get(params[:student_id])
    @solutions = Solution.all(:account_id => params[:student_id], :assignment_id => params[:assignment_id])
    render 'solutions/index'
  end

  # for THE student
  get :index, :map => '/assignments/:assignment_id/my/solutions'  do
    @solutions = Solution.all(:account => current_account, :assignment_id => params[:assignment_id])
    render 'solutions/my_index'
  end

  get :new, :map => '/assignments/:assignment_id/solutions/new' do
    @title = pat(:new_title, :model => 'solution')
		@solution = Solution.new( :account => current_account,:assignment => @assignment )
    render 'solutions/new'
  end

  post :create, :map => '/assignments/:assignment_id/solutions/create' do
		errors = []
		input_file = params[:solution][:file]
    @solution= Solution.new( :account_id => current_account.id,
            :assignment => @assignment, :file => input_file[:filename] )

    DataMapper::Transaction.new(DataMapper.repository(:default).adapter) do |trx|
      if @solution.save
				@solution_generic_file = SolutionGenericFile.new( :solution => @solution, 
              :name => input_file[:filename] )
        errors << @solution_generic_file.errors if not @solution_generic_file.save
				begin
		    	storage_gateway = Storage::StorageGateways.get_gateway
 	 	  	 	storage_gateway.upload(@solution_generic_file.path, input_file[:tempfile])
				rescue Storage::FileUploadFailedError => e
					errors << t('solutions.errors.upload_failed')
				end
			else
				errors << @solution.errors
			end

      trx.rollback() if not errors.empty?
		end # End of transaction

		if errors.empty?
    	@title = pat(:create_title, :model => "solution #{@solution.id}")
    	flash[:success] = pat(:create_success, :model => 'Solution')
			redirect(url(:solutions, :index, :assignment_id => @assignment.id )) 
		else
    	@title = pat(:create_title, :model => 'solution')
    	flash.now[:error] = errors
    	render 'solutions/new'
    end
  end

	get :file, :map => '/solutions/:solution_id/file' do
		solution = Solution.find( params[:solution_id] )
		#debugger
		if solution.nil?	
			conveys_warning( params[:id], 404 )
		end

		#if solution.account != current_account
		#	conveys_warning( params[:id], 404 )
		#end

		files = solution.solution_generic_files
		if files.nil? or files.empty?
			conveys_warning( params[:id], 404 )
		end

		file = files.first

		storage_gateway = Storage::StorageGateways.get_gateway
		storage_gateway.download( file.path )
	end
end
