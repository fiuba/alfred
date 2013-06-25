Alfred::App.controllers :assignment_generic_file, :parent => :assignment do
  
  get :index do
    @title = t('assignments.files.title')
    @assignment = Assignment.find(params[:assignment_id])
    @files = AssignmentGenericFile.all(:assignment_id => params[:assignment_id]) || []
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
    @assignment_generic_file.save
    
    # if @assignment.save
    #   @title = pat(:create_title, :model => "assignment #{@assignment.id}")
    #   flash[:success] = pat(:create_success, :model => 'Assignment')
    #   params[:save_and_continue] ? redirect(url(:assignments, :index)) : redirect(url(:assignments, :edit, :id => @assignment.id))
    # else
    #   @title = pat(:create_title, :model => 'assignment')
    #   flash.now[:error] = pat(:create_error, :model => 'assignment')
    #   render 'assignments/new'
    # end
  end

  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  

end
