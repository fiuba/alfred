Alfred::App.controllers :corrections, :parent => :course do
	before do
    @course = current_course
    @teacher = current_account

    halt 403 if @teacher.is_student?
	end
  
  get :index do
		@title = "Corrections"
		@corrections = Correction.all(:teacher => @teacher)
    render 'corrections/index'
  end

	post :create do
		solution = Solution.find_by_id( params[:correction][:solution_id] )
		@correction = Correction.new( :teacher => @teacher, :solution => solution)
		if @correction.save 
    	flash[:success] = pat(:create_success, :model => 'correction')
			redirect_back_or_default( url(:corrections, :edit, :id => @correction.id, :course_id => @course.id) )
		else 
      flash.now[:error] = pat(:create_error, :model => 'correction')
			redirect_back_or_default( url(:corrections, :index) )
		end
	end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "corrections #{params[:id]}")
    @correction = Correction.get(params[:id].to_i)
    if @correction
      render 'corrections/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'corrections', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "correction #{params[:id]}")
    @correction = Correction.get(params[:id].to_i)
    if @correction
      if @correction.update(params[:correction])
        flash[:success] = pat(:update_success, :model => 'Correction', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:corrections, @correction.teacher.id, :index)) :
          redirect(url(:corrections, @correction.teacher.id, :edit, :id => @correction.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'correction')
        render 'corrections/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'correction', :id => "#{params[:id]}")
      halt 404
    end
  end

end
