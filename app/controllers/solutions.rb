Alfred::App.controllers :solutions do
	
  get :index do
    @title = "Solutions"
		@solutions = Solution.all( :account => current_account )
    render 'solutions/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'solution')
    @solution =	Solution.new
    @assignments = Assignment.all
    render 'solutions/new'
  end

  post :create do
		errors = []
		input_file = params[:solution][:file]
    @solution= Solution.new(params[:solution])
		@solution.file = input_file[:filename]

		Database::Transaction.within do |tx, tx_errors|
      if @solution.save
				@solution_generic_file = 
					SolutionGenericFile.create( :solution => @solution, :name => input_file[:filename] )
				begin
		    	storage_gateway = Storage::StorageGateways.get_gateway
 	 	  	 	storage_gateway.upload(@solution_generic_file.path, input_file[:tempfile])
				rescue Storage::FileUploadFailedError => e
					# TODO Add error information for user to know what it has happened
					tx_errors << t('solutions.errors.upload_failed')
				end
			else
				tx_errors << @solutions.errors
			end
			errors = tx_errors
		end # End of transaction

		if errors.empty?
    	@title = pat(:create_title, :model => "solution #{@solution.id}")
    	flash[:success] = pat(:create_success, :model => 'Solution')
    	params[:save_and_continue] ? \
							redirect(url(:solutions, :index)) : \
							redirect(url(:solutions, :edit, :id => @solution.id))
		else
    	@title = pat(:create_title, :model => 'solution')
    	flash.now[:error] = pat(:create_error, :model => 'solution')
    	@assignments = Assignment.all
    	render 'solutions/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "solution #{params[:id]}")
    @solution = Solution.get(params[:id].to_i)
    if @solution
      @assignments = Assignment.all
      render 'solutions/edit'
    else
			conveys_warning( 
				pat(:create_error, :model => 'solution', :id => "#{params[:id]}"),
				404 )
    end
  end

  delete :destroy, :with => :id do
    @title = "Solutions"
    solution = Solution.get(params[:id].to_i)

		# Check existence
    if solution.nil?
			conveys_warning( 
				pat(:delete_warning, :model => 'solution', :id => "#{params[:id]}"),
				404 )
    end

		# Check ownership
		if not solution.account == current_account
			conveys_warning( 
				pat(:delete_warning, :model => 'solution', :id => "#{params[:id]}"),
				403 )
		end

		# Check associated files
		if solution.solution_generic_files.empty?
			conveys_warning( 
				pat(:delete_warning, :model => 'solution', :id => "#{params[:id]}"),
				404 )
		end

		store_file = solution.solution_generic_files.first
		Database::Transaction.within do |tx, tx_errors|
			solution_deleted = solution.destroy

			if solution_deleted
      	flash[:success] = pat(:delete_success, :model => 'Solution', :id => "#{params[:id]}")

				begin
			  	storage_gateway = Storage::StorageGateways.get_gateway
 	 	 	  	storage_gateway.delete( store_file.path() )
				rescue Storage::FileDeleteError => e
					tx_errors << t('solutions.errors.delete_failed')
				end
      else
				flash[:error] = pat(:delete_error, :model => 'solution')
      end
		end	# Transaction end

    redirect url(:solutions, :index)
  end

	get :file, :with => :solution_id do
		solution = Solution.find( params[:solution_id] )

		if solution.nil?	
			conveys_warning( params[:id], 404 )
		end

		if solution.account != current_account
			conveys_warning( params[:id], 404 )
		end

		files = solution.solution_generic_files
		if files.nil? or files.empty?
			conveys_warning( params[:id], 404 )
		end

		file = files.first

		storage_gateway = Storage::StorageGateways.get_gateway
		storage_gateway.download( file.path )
	end

end
