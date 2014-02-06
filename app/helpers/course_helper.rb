Alfred::App.helpers do

	def current_course
		Course.active
	end

	def current_course=(course)
		session[:current_course] = course
	end
end