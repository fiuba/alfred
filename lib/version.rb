class Version

	MAYOR = 1
	MINOR = 3

	def self.current
		"#{MAYOR}.#{MINOR}.#{ENV['BUILD_NUMBER']}"
	end
end
