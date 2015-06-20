require 'fileutils'

class Storage::LocalGateway

  def upload(file_path, file)
    path = File.dirname(file_path)

    create_directory path

    File.open(File.join(ENV["HOME_PATH"], file_path), 'w') {|f| f.write File.read(file) }
  end

  def download file_path
    File.open(File.join(ENV["HOME_PATH"], file_path))
  end

  def metadata file_path
    { mime_type: "application/octet-stream" }
  end

  private
  def create_directory(path)
    unless File.directory?(File.join(ENV["HOME_PATH"], path))
      FileUtils.mkdir_p(File.join(ENV["HOME_PATH"], path))
    end
  end

end