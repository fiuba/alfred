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

  describe "#download" do

    it "should be exactly the same file that has been saved" do
      original_file = File.open(file)

      downloaded_file = local_gateway.download(file_path)

      expect(FileUtils.compare_file(downloaded_file, original_file)).to be_true
    end

    context "try to download with an invalid path" do

      it "should return a file not found error" do

        expect{ local_gateway.download("/invalid/path") }.to raise_error FileExceptions::FileNotFound
      end

    end
  end

end