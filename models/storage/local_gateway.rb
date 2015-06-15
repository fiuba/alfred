require 'fileutils'

class Storage::LocalGateway

  def upload(file_path, file)
    path = File.dirname(file_path)

    create_directory path

    File.open(File.join(Dir.home, file_path), 'w') {|f| f.write File.read(file) }
  end

  def download file_path
    File.open(File.join(Dir.home, file_path))
  end

  def metadata file_path
    { mime_type: "application/octet-stream" }
  end

  private
  def create_directory(path)
    unless File.directory?(File.join(Dir.home, path))
      FileUtils.mkdir_p(File.join(Dir.home, path))
    end
  end

end