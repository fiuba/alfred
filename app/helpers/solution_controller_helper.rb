# Helper methods defined here can be accessed in any controller or view in the application

Alfred::App.helpers do
  def file_download_link(file_path)
    storage_gateway = Storage::StorageGateways.get_gateway

  	storage_gateway.share(file_path)[:url]
  end

	def conveys_warning( msg, warning_code )
  	flash[:warning] = msg
  	halt warning_code
	end

  def formats_date( date )
    date.strftime("%Y-%m-%d %H:%M:%S") if !date.nil?
  end
end
