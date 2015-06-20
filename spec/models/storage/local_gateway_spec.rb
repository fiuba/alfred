require "spec_helper"

describe Storage::LocalGateway do

  before :each do
    ENV["HOME_PATH"] = Dir.home
  end

  let!(:file) { simple_file "file.txt", "A simple content" }
  let!(:file_path) { "/spec/local-storage" }
  subject(:local_gateway) { Storage::LocalGateway.new }

  describe "#upload" do

    let!(:complete_file_path) { ENV["HOME_PATH"]+file_path }

    before :each do
      local_gateway.upload(file_path, file)
    end

    it "should create a file into the file path" do

      expect(File.exists?(complete_file_path)).to be_true
    end

    it "should not modify the file content after upload it" do

      expect(file_content_of complete_file_path).to eq("A simple content")
    end

  end

end