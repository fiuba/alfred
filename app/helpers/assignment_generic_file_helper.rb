# Helper methods defined here can be accessed in any controller or view in the application

Alfred::App.helpers do
  def file_download_link(file_path)
    storage_gateway = Storage::StorageGateways.get_gateway

  	storage_gateway.share(file_path)[:url]
  end
end
