class Version

	MAYOR = 1
	MINOR = 0

	def self.current
		"#{MAYOR}.#{MINOR}.#{ENV['BUILD_NUMBER']}"
	end
end