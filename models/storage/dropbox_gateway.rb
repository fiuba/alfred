class Storage::FileUploadFailedError < StandardError
	def initialize(dropbox_error)
		super(dropbox_error.message)
	end
end

class Storage::FileMetadataError < StandardError
	def initialize(dropbox_error)
		super(dropbox_error.message)
	end
end

class Storage::FileDownloadError < StandardError
	def initialize(dropbox_error)
		super(dropbox_error.message)
	end
end

class Storage::FileShareError < StandardError
	def initialize(dropbox_error)
		super(dropbox_error.message)
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

			[ share['url'], DateTime.parse(share['expires']) ]
		rescue DropboxError => de
			raise Storage::FileShareError.new(de)
		end
	end
end