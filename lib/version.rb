class Version

	MAYOR = 1
	MINOR = 2

	def self.current
		"#{MAYOR}.#{MINOR}.#{ENV['BUILD_NUMBER']}"
	end
end
