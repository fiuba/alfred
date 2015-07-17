require 'fileutils'
require 'exceptions/file_exceptions'

class Storage::LocalGateway
  include FileExceptions

  def upload(file_path, file)
    path = File.dirname(file_path)

    create_directory path

    File.open(File.join(ENV["HOME_PATH"], file_path), 'w') {|f| f.write File.read(file) }
  end

  def download file_path
    verify_file_existence! file_path

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

  def verify_file_existence! file_path
    raise FileNotFound.new("File in #{file_path} not found") unless File.exists?(ENV["HOME_PATH"]+file_path)
  end

end