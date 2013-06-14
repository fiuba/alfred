require 'spec_helper'

describe Storage::DropboxGateway do
	before (:all) do
		ENV['DROPBOX_APP_KEY']='12345abcde'
		ENV['DROPBOX_APP_SECRET']='12345abcde'
		ENV['DROPBOX_REQUEST_TOKEN_KEY']='12345abcde'
		ENV['DROPBOX_REQUEST_TOKEN_SECRET']='12345abcde'
		ENV['DROPBOX_AUTH_TOKEN_KEY']='12345abcde'
		ENV['DROPBOX_AUTH_TOKEN_SECRET']='12345abcde'
	end

	subject(:dropbox_gateway) { Storage::DropboxGateway.new }

	it "should upload a new file" do
	  VCR.use_cassette('dropbox_upload_new_file') do
	  	dropbox_gateway.upload('test.txt', '/my_files/test.txt').should == '/test.txt'
	  end
	end

	it "should raise error if file cannot be uploaded" do
	  VCR.use_cassette('dropbox_upload_new_file_fails') do
	  	expect { dropbox_gateway.upload('fail_when_uploading_this_file.txt', '/my_files/fail_when_uploading_this_file.txt') }.to raise_error(Storage::FileUploadFailedError)
	  end
	end

	it "should retrieve uploaded file metadata" do
		VCR.use_cassette('dropbox_retrieve_metadata') do
	  	metadata = dropbox_gateway.metadata('test.txt')

	  	metadata.should_not be_nil
	  	metadata['path'].should == '/test.txt'
	  	DateTime.parse(metadata['modified']).should == DateTime.parse('Fri, 01 Jun 2013 00:00:00 +0000')
	  	metadata['bytes'].should == 29
	  	metadata['mime_type'].should == 'text/plain'
	  end
	end

	it "should raise error if file cannot be found when requesting metadata" do
	  VCR.use_cassette('dropbox_retrieve_metadata_for_inexistent_file') do
	  	expect { dropbox_gateway.metadata('foo.bar') }.to raise_error(Storage::FileMetadataError)
	  end
	end

	it "should retrieve uploaded file" do
	  VCR.use_cassette('dropbox_retrieve_file') do
	  	file_content = dropbox_gateway.download('test.txt')

	  	file_content.should == 'this is a test file'
	  end
	end

	it "should raise an error if file cannot be found when requesting download" do
	  VCR.use_cassette('dropbox_retrieve_file_for_inexistent_file') do
	  	expect { dropbox_gateway.download('foo.bar') }.to raise_error(Storage::FileDownloadError)
	  end
	end

	it "should create share link" do
	  VCR.use_cassette('dropbox_create_share_link') do
	  	share_link, expiration = dropbox_gateway.share('test.txt')

	  	share_link.should =~ /http:\/\/www\.dropbox\.com\/.*\/test.txt/
	  	expiration.should == DateTime.parse('Fri, 01 Jul 2013 00:00:00 +0000')
	  end
	end

	it "should raise an error if file cannot be found when creating share link" do
	  VCR.use_cassette('dropbox_create_share_link_for_inexistent_file') do
	  	expect { dropbox_gateway.share('foo.bar') }.to raise_error(Storage::FileShareError)
	  end
	end
end