module Storage
	module StorageGateways
		def self.get_gateway
			Storage::DropboxGateway.new
		end
	end
end