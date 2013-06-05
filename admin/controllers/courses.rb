Alfred::Admin.controllers :courses do
  get :index do
    @title = "Courses"
    @courses = Course.all
    render 'courses/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'course')
    @course = Course.new
    render 'courses/new'
  end

  post :create do
    @course = Course.new(params[:course])
    if @course.save
      @title = pat(:create_title, :model => "course #{@course.id}")
      flash[:success] = pat(:create_success, :model => 'Course')
      params[:save_and_continue] ? redirect(url(:courses, :index)) : redirect(url(:courses, :edit, :id => @course.id))
    else
      @title = pat(:create_title, :model => 'course')
      flash.now[:error] = pat(:create_error, :model => 'course')
      render 'courses/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "course #{params[:id]}")
    @course = Course.get(params[:id].to_i)
    if @course
      render 'courses/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'course', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "course #{params[:id]}")
    @course = Course.get(params[:id].to_i)
    if @course
      if @course.update(params[:course])
        flash[:success] = pat(:update_success, :model => 'Course', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:courses, :index)) :
          redirect(url(:courses, :edit, :id => @course.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'course')
        render 'courses/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'course', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Courses"
    course = Course.get(params[:id].to_i)
    if course
      if course.destroy
        flash[:success] = pat(:delete_success, :model => 'Course', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'course')
      end
      redirect url(:courses, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'course', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Courses"
    unless params[:course_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'course')
      redirect(url(:courses, :index))
    end
    ids = params[:course_ids].split(',').map(&:strip).map(&:to_i)
    courses = Course.all(:id => ids)
    
    if courses.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Courses', :ids => "#{ids.to_sentence}")
    end
    redirect url(:courses, :index)
  end
end
