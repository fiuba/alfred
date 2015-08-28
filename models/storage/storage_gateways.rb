module Storage
	module StorageGateways
		def self.get_gateway
			if PADRINO_ENV=='development'
				Storage::StubGateway.new
			else
				Alfred::App.customizer.storage_provider
			end
		end
	end
end
