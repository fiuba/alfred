class AssignmentStatus

	attr_accessor :assignment_id
	attr_accessor :solution_count
	attr_accessor :latest_solution_date
	attr_accessor :corrector_name
	attr_accessor :status 
	attr_accessor :name
	attr_accessor :deadline

	def can_be_assigned?
		![:solution_pending, :correction_passed, :correction_failed].include? self.status
	end
end