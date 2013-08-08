Alfred::App.controllers :assignment_file, :parent => :assignments do
  get :download do
    @assignment = Assignment.find(params[:assignment_id])
    halt 404 if @assignment.nil? || @assignment.assignment_file.nil?

    storage_gateway = Storage::StorageGateways.get_gateway
    file_metadata = storage_gateway.metadata(@assignment.assignment_file.path)

    response.headers['Content-Type'] = file_metadata['mime_type']
    response.headers['Content-Disposition'] = "attachment; filename=#{@assignment.assignment_file.name}"
    storage_gateway.download(@assignment.assignment_file.path)
  end

  delete :destroy, :with => :id do
    assignment_file = AssignmentFile.get(params[:id].to_i)
    if assignment_file
      assignment_file.transaction do |tx|
        begin
          file_path = assignment_file.path
          record_deleted = assignment_file.destroy

          if record_deleted
            storage_gateway = Storage::StorageGateways.get_gateway
            storage_gateway.delete(file_path)

            flash[:success] = pat(:delete_success, :model => 'AssignmentFile', :id => "#{params[:id]}")
          else
            flash[:error] = pat(:delete_error, :model => 'AssignmentFile')
          end

          Oj.dump({ 'message' => t('assignments.files.delete.success') })
        rescue Storage::FileDeleteError => e
          tx.rollback
          Oj.dump({ 'message' => t('assignments.files.delete.error') })
        end
      end
    else
      halt 404
    end
  end
end
