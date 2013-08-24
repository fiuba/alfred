Alfred::App.controllers :my do

  define_method :is_file_specified? do |params|
    solution_params = params[:solution]
    return false unless solution_params.has_key?('file')
    true
  end

  get :assigments, :parent => :courses do
    assignments = Assignment.find_by_course(current_course)
    @assignment_status = []
    assignments.each do | assignment |
      @assignment_status << current_account.status_for_assignment(assignment)
    end
    render 'my/assignments'
  end

  get :solutions, :map => '/my/assignments/:assignment_id/solutions' do
    @assignment = Assignment.get(params[:assignment_id])
    @solutions = Solution.all(:account => current_account, :assignment_id => params[:assignment_id])
    render 'my/solutions'
  end

  get :new_solution, :map => '/my/assignments/:assignment_id/solutions/new' do
    @assignment = Assignment.get(params[:assignment_id])
    @solution = Solution.new( :account => current_account,:assignment => @assignment )
    render 'my/new_solution'
  end

  post :create_solution, :map => '/my/assignments/:assignment_id/solutions/create' do
    errors = []

    @assignment = Assignment.get(params[:assignment_id])
    @solution= Solution.new( :account_id => current_account.id,
            :assignment => @assignment )

    if is_file_specified?(params)
      input_file = params[:solution][:file]
      @solution.file = input_file[:filename]

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
    else
      errors << t('solutions.errors.file_absent')
    end # End of if

    if errors.empty?
      @title = pat(:create_title, :model => "solution #{@solution.id}")
      flash[:success] = pat(:create_success, :model => 'Solution')
      redirect(url(:my, :solutions, :assignment_id => @assignment.id )) 
    else
      @title = pat(:create_title, :model => 'solution')
      flash.now[:error] = errors
      render 'my/new_solution'
    end
  end

  get :show_correction, :map => '/my/assignments/:assignment_id/corrections/:correction_id' do
    @correction = Correction.get(params[:correction_id])
    
    render 'my/correction'
  end

=begin
  TODO: eso deberia ser para ver los detalles de una solución
  get '/assigments/:assignment_id/solutions/:solution_id' do
    render 'students/solution_detail'
  end
=end

end
