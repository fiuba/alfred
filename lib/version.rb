class Version

	MAYOR = 1
	MINOR = 1

	def self.current
		"#{MAYOR}.#{MINOR}.#{ENV['BUILD_NUMBER']}"
	end
end
