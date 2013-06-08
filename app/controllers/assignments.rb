Alfred::App.controllers :assignments do
  get :index do
    @title = "Assignments"
    @assignments = Assignment.all
    render 'assignments/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'assignment')
    @assignment = Assignment.new
    @courses = Course.all(:active => true)
    render 'assignments/new'
  end

  post :create do
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      @title = pat(:create_title, :model => "assignment #{@assignment.id}")
      flash[:success] = pat(:create_success, :model => 'Assignment')
      params[:save_and_continue] ? redirect(url(:assignments, :index)) : redirect(url(:assignments, :edit, :id => @assignment.id))
    else
      @title = pat(:create_title, :model => 'assignment')
      flash.now[:error] = pat(:create_error, :model => 'assignment')
      render 'assignments/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "assignment #{params[:id]}")
    @assignment = Assignment.get(params[:id].to_i)
    if @assignment
      @courses = Course.all(:active => true)
      render 'assignments/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'assignment', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "assignment #{params[:id]}")
    @assignment = Assignment.get(params[:id].to_i)
    if @assignment
      if @assignment.update(params[:assignment])
        flash[:success] = pat(:update_success, :model => 'Assignment', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:assignments, :index)) :
          redirect(url(:assignments, :edit, :id => @assignment.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'assignment')
        render 'assignments/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'assignment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Assignments"
    assignment = Assignment.get(params[:id].to_i)
    if assignment
      if assignment.destroy
        flash[:success] = pat(:delete_success, :model => 'Assignment', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'assignment')
      end
      redirect url(:assignments, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'assignment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Assignments"
    unless params[:assignment_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'assignment')
      redirect(url(:assignments, :index))
    end
    ids = params[:assignment_ids].split(',').map(&:strip).map(&:to_i)
    assignments = Assignment.all(:id => ids)
    
    if assignments.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Assignments', :ids => "#{ids.to_sentence}")
    end
    redirect url(:assignments, :index)
  end
end
