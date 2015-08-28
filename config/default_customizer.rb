module Alfred
	class DefaultCustomizer

		def emails_tag
			'[FIUBA-ALGO]'
		end

		def storage_provider
			Storage::DropboxGateway.new
		end
		
	end
end