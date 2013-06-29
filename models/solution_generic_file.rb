class CannotUpdateNameError < StandardError
	def initialize
		super("File's name cannot be updated after being set.")
	end
end

class SolutionGenericFile
	include DataMapper::Resource

	storage_names[:default] = 'solution_generic_files'

  before :save, :complete_path

	belongs_to :solution

  property :id, Serial
	property :inner_path, String, :accessor => :protected, :field => 'path'

	validates_presence_of :inner_path
	validates_format_of :inner_path, :with => /.+(?!\/temp\/).+/i

	def name
		return nil if self.inner_path.nil?
		Pathname.new(self.inner_path).basename.to_s
	end

	def name=(new_name)
		return if new_name.nil? || new_name.empty?

		new_name = new_name.downcase
		raise CannotUpdateNameError if self.inner_path && self.name != new_name

		self.inner_path = calculate_path(new_name)
	end

	def path
		self.inner_path
	end

	def complete_path
		if self.path =~ /^\/solution\/temp\/.*/ && !self.solution.nil?
			self.inner_path = calculate_path(self.name)
		end
	end

	def calculate_path(file_name)
		path = ''
		if !self.solution || self.solution.id.blank?
			path = "/solution/temp/#{file_name}"
		else
			path = "/solution/#{solution.id}/#{file_name}"
		end

		return path
	end
end
