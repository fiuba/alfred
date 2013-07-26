Alfred::App.controllers :corrections do
	before do
    @course = current_course
    @teacher = current_account

    halt 403 if @teacher.is_student?
	end
  
  get :index, :parent => :courses do
		@corrections = Correction.all(:teacher => @teacher)
    render 'corrections/index'
  end

	post :create, :provides => :json do
		student = Account.get(params[:student_id])
		assignment = Assignment.get(params[:assignment_id])

		Correction.create_for_teacher(current_account, student, assignment)

		new_status = correction_status_label(student.status_for_assignment(assignment.reload).status)
		Oj.dump({ 'message' => t('corrections.creation_succeeded'), 'assigned_teacher' => current_account.full_name, 'new_status' => new_status })
	end

	get :index, :parent => :assignment do
		@assignment = Assignment.get(params[:assignment_id])

		@students_with_assignment_status = []
    @assignment.course.students.each do | student |
      @students_with_assignment_status << { :student => student, :assignment_status => student.status_for_assignment(@assignment) }
    end

		# TODO: Temporary view, need to move the other index action out of this controller
		render 'corrections/all_index'
	end

  get :edit, :parent => :courses, :with => :id do
    @title = pat(:edit_title, :model => "corrections #{params[:id]}")
    @correction = Correction.get(params[:id].to_i)
    if @correction
      render 'corrections/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'corrections', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :parent => :courses, :with => :id do
    @title = pat(:update_title, :model => "correction #{params[:id]}")
    @correction = Correction.get(params[:id].to_i)
    if @correction
      # Nullifies to let validation pass
      grade = params[:correction][:grade]
      params[:correction][:grade] = ( grade.blank? ) ? nil : grade
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
