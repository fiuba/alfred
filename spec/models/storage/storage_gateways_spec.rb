require 'spec_helper'

describe Storage::StorageGateways do
	it "should return dropbox storage gateway" do
		storage_gateway = Storage::StorageGateways.get_gateway

		storage_gateway.should be_an_instance_of(Storage::DropboxGateway)
	end
end