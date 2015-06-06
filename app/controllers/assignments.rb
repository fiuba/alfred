Alfred::App.controllers :assignments do

  get :index, :parent => :courses do
    @assignments = Assignment.all(:course => current_course)
    render 'assignments/index'
  end

  get :students, :map => '/assignments/:assignment_id/students'  do
    @assignment = Assignment.get(params[:assignment_id])

    @students_with_assignment_status = []
    @assignment.course.students.each do | student |
      @students_with_assignment_status << { :student => student, :assignment_status => student.status_for_assignment(@assignment) }
    end

    render 'assignments/students'
  end

  get :new do
    @title = pat(:new_title, :model => 'assignment')
    @assignment = Assignment.new
    render 'assignments/new'
  end

  get 'assignment_id/students/:student_id/solutions' do   
    student = Account.get(params[:student_id])
    @solutions = Solution.all( :account => student,
     :assignment => @assignment )
    render 'solutions/index'
  end

  # TODO: Refactor code to remove duplication (Trello#37)
  post :create do
    errors = []
    Assignment.transaction do |trx|
      begin
        @assignment = Assignment.new(params[:assignment].merge({ :course_id => current_course.id }))
        if @assignment.deadline == ''
          errors << t('assignments.errors.deadline_not_chosen')
        elsif @assignment.deadline <= Date.today
            errors << t('assignments.errors.deadline_passed')
        elsif @assignment.save
          if params[:assignment_file]
            file_io = params[:assignment_file]['file']
            @assignment_file = AssignmentFile.new(:assignment => @assignment, :name => file_io[:filename])
            storage_gateway = Storage::StorageGateways.get_gateway
            storage_gateway.upload(@assignment_file.path, file_io[:tempfile])

            if !@assignment_file.save
              errors << @assignment_file.errors
            end

          end
          @title = pat(:create_title, :model => "assignment #{@assignment.id}")
          flash[:success] = pat(:create_success, :model => 'Assignment')
          params[:save_and_continue] ? redirect(url(:assignments, :index, :course_id => current_course.id)) : redirect(url(:assignments, :edit, :id => @assignment.id, :course_id => current_course.id))
        else
          errors << @assignment.errors
        end
      rescue DataObjects::Error
        trx.rollback
      end
    end

    if errors.size > 0
      @title = pat(:create_title, :model => 'assignment')
      flash.now[:error] = errors #pat(:create_error, :model => 'assignment')
    end

    render 'assignments/new'
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "assignment #{params[:id]}")
    @assignment = Assignment.get(params[:id].to_i)
    if @assignment
      render 'assignments/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'assignment', :id => "#{params[:id]}")
      halt 404
    end
  end

  # TODO: Refactor code to remove duplication (Trello#37)
  put :update, :with => :id do
    @title = pat(:update_title, :model => "assignment #{params[:id]}")
    @assignment = Assignment.get(params[:id].to_i)
    if @assignment
      Assignment.transaction do |trx|
        begin
          if params[:assignment]["deadline"] == ''
            flash.now[:error] << t('assignments.errors.deadline_not_chosen')
            render 'assignments/new'
          elsif params[:assignment]["deadline"].to_date <= Date.today
            flash.now[:error] = t('assignments.errors.deadline_passed')
            render 'assignments/new'
          elsif @assignment.update(params[:assignment])
            if params[:assignment_file]
              file_io = params[:assignment_file]['file']
              if file_io
                @assignment_file = AssignmentFile.new(:assignment => @assignment, :name => file_io[:filename])
                storage_gateway = Storage::StorageGateways.get_gateway
                storage_gateway.upload(@assignment_file.path, file_io[:tempfile])
                @assignment_file.save
              end
            end
            flash[:success] = pat(:update_success, :model => 'Assignment', :id =>  "#{params[:id]}")
            params[:save_and_continue] ?
              redirect(url(:assignments, :index, :course_id => current_course.id)) :
              redirect(url(:assignments, :edit, :id => @assignment.id, :course_id => current_course.id))
          else
            flash.now[:error] = pat(:update_error, :model => 'assignment')
            render 'assignments/edit'
          end
        rescue DataObjects::Error
          trx.rollback
        end
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
      if assignment.destroy!
        flash[:success] = pat(:delete_success, :model => 'Assignment', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'assignment')
      end
      redirect url(:assignments, :index, :course_id => current_course.id)
    else
      flash[:warning] = pat(:delete_warning, :model => 'assignment', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Assignments"
    unless params[:assignment_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'assignment')
      redirect(url(:assignments, :index, :course_id => current_course.id))
    end
    ids = params[:assignment_ids].split(',').map(&:strip).map(&:to_i)
    assignments = Assignment.all(:id => ids)
    
    if assignments.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Assignments', :ids => "#{ids.to_sentence}")
    end
    redirect url(:assignments, :index, :course_id => current_course.id)
  end
end
