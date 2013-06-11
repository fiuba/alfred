Alfred::App.controllers :solutions do

	before do
		unless logged_in?
			store_location
			redirect url( :login )
		end
	end
	
  get :index do
    @title = "Solutions"
		@solutions = Solution.all
    render 'solutions/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'solution')
    @solution =	Solution.new( :account => current_account )
    @assignments = Assignment.all
    render 'solutions/new'
  end

  post :create do
    puts params[:solution]
    @solution= Solution.new(params[:solution])
    if @solution.save
      @title = pat(:create_title, :model => "solution #{@solution.id}")
      flash[:success] = pat(:create_success, :model => 'Solution')
      params[:save_and_continue] ? redirect(url(:solutions, :index)) : redirect(url(:solutions, :edit, :id => @solution.id))
    else
      @title = pat(:create_title, :model => 'solution')
      flash.now[:error] = pat(:create_error, :model => 'solution')
      @assignments = Assignment.all
      render 'solutions/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "solution #{params[:id]}")
    @solution = Solution.get(params[:id].to_i)
    if @solution
      @assignments = Assignment.all
      render 'solutions/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'solution', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "solution #{params[:id]}")
    @solution = Solution.get(params[:id].to_i)
    if @solution
      if @solution.update(params[:solution])
        flash[:success] = pat(:update_success, :model => 'Solution', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:solutions, :index)) :
          redirect(url(:solutions, :edit, :id => @solution.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'solution')
        render 'solutions/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'solution', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Solutions"
    solution = Solution.get(params[:id].to_i)
    if solution
      if solution.destroy
        flash[:success] = pat(:delete_success, :model => 'Solution', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'solution')
      end
      redirect url(:solutions, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'solution', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
		puts "destroy_many"
    @title = "Solutions"
    unless params[:solution_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'solution')
      redirect(url(:solutions, :index))
    end
    ids = params[:solution_ids].split(',').map(&:strip).map(&:to_i)
    solutions = Solution.all(:id => ids)
    
    if solutions.destroy
    
      flash[:success] = pat(:destroy_many_success, :model => 'Solutions', :ids => "#{ids.to_sentence}")
    end
    redirect url(:solutions, :index)
  end

end
