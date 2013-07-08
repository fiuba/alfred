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

end
