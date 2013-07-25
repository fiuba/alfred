Alfred::App.controllers :corrections do
  get :index, :with => :teacher_id do
		@title = "Corrections"
		account = Account.find_by_id( params[:teacher_id] )
		halt 403 if not account.is_teacher?
		@corrections = Correction.all(:teacher => account)
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

end
