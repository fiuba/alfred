class Storage::Error < StandardError
	def initialize(dropbox_error)
		super(dropbox_error.message)
	end
end

class Storage::FileUploadFailedError < Storage::Error
	def initialize(dropbox_error)
		super(dropbox_error)
	end
end

class Storage::FileMetadataError < Storage::Error
	def initialize(dropbox_error)
		super(dropbox_error)
	end
end

class Storage::FileDownloadError < Storage::Error
	def initialize(dropbox_error)
		super(dropbox_error)
	end
end

class Storage::FileShareError < Storage::Error
	def initialize(dropbox_error)
		super(dropbox_error)
	end
end

class Storage::FileDeleteError < Storage::Error
	def initialize(dropbox_error)
		super(dropbox_error)
	end
end

class Storage::DropboxGateway
	def initialize
    @session = DropboxSession.new(ENV['DROPBOX_APP_KEY'], ENV['DROPBOX_APP_SECRET'])
    @session.set_request_token(ENV['DROPBOX_REQUEST_TOKEN_KEY'], ENV['DROPBOX_REQUEST_TOKEN_SECRET'])
    @session.set_access_token(ENV['DROPBOX_AUTH_TOKEN_KEY'], ENV['DROPBOX_AUTH_TOKEN_SECRET'])

    @client = DropboxClient.new(@session, :app_folder)
	end

	def upload(file_path, file)
		begin
			response = @client.put_file(file_path, file, true)
			response['path']
		rescue DropboxError => de
			raise Storage::FileUploadFailedError.new(de)
		end
	end

	def metadata(file_path)
		begin
			@client.metadata(file_path)
		rescue DropboxError => de
			raise Storage::FileMetadataError.new(de)
		end
	end

	def download(file_path)
		begin
			@client.get_file(file_path)
		rescue DropboxError => de
			raise Storage::FileDownloadError.new(de)
		end
	end

	def share(file_path)
		begin
			share = @client.shares(file_path)

			{ :url => share['url'], :expiration_date => DateTime.parse(share['expires']) }
		rescue DropboxError => de
			raise Storage::FileShareError.new(de)
		end
	end

	def delete(file_path)
		begin
			@client.file_delete(file_path)
		rescue DropboxError => de
			raise Storage::FileDeleteError.new(de)
		end
	end
end