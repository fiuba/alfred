Alfred::App.controllers :assignment_generic_file, :parent => :assignment do
  
  get :index do
    @title = t('assignments.files.title')
    @assignment = Assignment.find(params[:assignment_id])
    @files = @assignment.assignment_generic_files || [ ]
    render 'assignment_generic_files/index'
  end

  get :new do
    @title = t('assignments.files.new.title')
    @assignment = Assignment.find(params[:assignment_id])
    @file = AssignmentGenericFile.new(:assignment => @assignment)
    render 'assignment_generic_files/new'
  end

  post :create do
    file_io = params[:assignment_generic_file]['file']
    @assignment = Assignment.find(params[:assignment_id])
    @assignment_generic_file = AssignmentGenericFile.new(:assignment => @assignment, :name => file_io[:filename])

    storage_gateway = Storage::StorageGateways.get_gateway
    storage_gateway.upload(@assignment_generic_file.path, file_io[:tempfile].read)
    
    
    if @assignment_generic_file.save
      redirect(url(:assignments, :index))
    else
      @title = t('assignments.files.new.title')
      flash.now[:error] = pat(:create_error, :model => 'assignment_generic_file')
      render 'assignment_generic_files/new'
    end
  end

  delete :destroy, :with => :id do
    @title = "Assignments"
    assignment_generic_file = AssignmentGenericFile.get(params[:id].to_i)
    if assignment_generic_file
      if assignment_generic_file.destroy
        flash[:success] = pat(:delete_success, :model => 'AssignmentGenericFile', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'AssignmentGenericFile')
      end
      redirect url(:assignment, :generic, :file, :index, :assignment_id => params[:assignment_id])
    else
      flash[:warning] = pat(:delete_warning, :model => 'AssignmentGenericFile', :id => "#{params[:id]}")
      halt 404
    end
  end
end
