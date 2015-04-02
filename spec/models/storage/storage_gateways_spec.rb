require 'spec_helper'

describe Storage::StorageGateways do
#	Comentado por Emanuel Dubor con motivo de la modificacion a la clase StorageGateway
#	it "should return dropbox storage gateway" do
#		storage_gateway = Storage::StorageGateways.get_gateway
#
#		storage_gateway.should be_an_instance_of(Storage::DropboxGateway)
#	end

	it "should know how to upload files" do
		storage_gateway = Storage::StorageGateways.get_gateway
		expect(storage_gateway).to respond_to :upload
	end
end
