Alfred::App.controllers :corrections do
  
  get :index, :with => :teacher_id do
		@title = "Corrections"
		account = Account.find_by_id( params[:teacher_id] )
		halt 403 if not account.is_teacher?
		@corrections = Correction.all(:teacher => account)
    render 'corrections/index'
  end

	get :new do
	end

	get :index, :parent => :assignment  do
		@assignment = Assignment.get(params[:assignment_id])
		
		@students_with_assignment_status = []
    @assignment.course.students.each do | student |
      @students_with_assignment_status << { :student => student, :assignment_status => student.status_for_assignment(@assignment) }
    end

		# TODO: Temporary view, need to move the other index action out of this controller
		render 'corrections/all_index'
	end

end
