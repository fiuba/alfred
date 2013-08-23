Alfred::App.helpers do

	def current_course
		Course.first
	end

	def current_course=(course)
		session[:current_course] = course
	end
end