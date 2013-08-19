Alfred::App.controllers :corrections do
	before do
    @course = current_course
    @teacher = current_account

    halt 403 if @teacher.is_student?
	end

  before :edit, :update do
    @correction = Correction.get(params[:id])
  end
  
  get :index, :parent => :courses do
		@corrections = Correction.all(:teacher => @teacher)
    render 'corrections/index'
  end

	post :create, :provides => :json do
		student = Account.get(params[:student_id])
		assignment = Assignment.get(params[:assignment_id])

		Correction.create_for_teacher(current_account, student, assignment)

		new_status = I18n.translate(student.status_for_assignment(assignment.reload).status)
		Oj.dump({ 'message' => t('corrections.creation_succeeded'), 'assigned_teacher' => current_account.full_name, 'new_status' => new_status })
	end

  get :edit, :parent => :courses, :with => :id do
    @title = pat(:edit_title, :model => "corrections #{params[:id]}")
    if @correction
      render 'corrections/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'corrections', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :parent => :courses, :with => :id do
    @title = pat(:update_title, :model => "correction #{params[:id]}")
    if @correction
      # Nullifies to let validation pass
      grade = params[:correction][:grade]
      params[:correction][:grade] = ( grade.blank? ) ? nil : grade
      if @correction.update(params[:correction])
        flash[:success] = pat(:update_success, :model => 'Correction', :id =>  "#{params[:id]}")
        if (params[:save_and_notify])
          deliver(:notification, :correction_result, @correction)          
        end
        redirect(url(:corrections, @correction.teacher.id, :index))
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
