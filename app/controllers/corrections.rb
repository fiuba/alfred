# encoding: UTF-8
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

  get :new, :parent => :solution  do
    solution = Solution.get(params[:solution_id])
    @correction = Correction.new(:teacher => current_account, :solution => solution)
    render 'corrections/new'
  end

	post :create, :parent => :solution, :provides => [:html, :json] do
    solution  = Solution.get(params[:solution_id])

		@correction = Correction.create(:solution => solution, :teacher => current_account)

    case content_type
      when :json
        new_status = I18n.translate(solution.account.status_for_assignment(solution.assignment.reload).status)
        Oj.dump({ 'message' => t('corrections.creation_succeeded'), 'assigned_teacher' => current_account.full_name, 'new_status' => new_status })
      when :html
        flash[:success] = pat(:create_success, :model => 'Corrección', :id =>  "#{@correction.id}")
        params[:save_and_continue] ?
          redirect(url(:corrections, @correction.teacher.id, :index)) :
          redirect(url(:corrections, :edit, :id => @correction.id))
		end
	end

  get :edit, :with => :id do
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
        flash[:success] = pat(:update_success, :model => 'Corrección', :id =>  "#{params[:id]}")
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
