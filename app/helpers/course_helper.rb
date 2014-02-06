Alfred::App.helpers do
	def current_course
		session[:current_course] ||= Course.active
	end

	def set_current_course(course)
		session[:current_course] = course
	end
end
