migration 19, :rename_assignment_generic_files do
  up do
    unless DataMapper.repository(:default).adapter.storage_exists?('assignment_files')
    	create_table :assignment_files do
        column :id, Integer, :serial => true
        column :path, String
        column :assignment_id, Integer
      end

      DataMapper.repository.adapter.execute('INSERT INTO assignment_files(path, assignment_id) SELECT path, assignment_id FROM assignment_generic_files')

      drop_table :assignment_generic_files
    end
  end

  down do
  	create_table :assignment_generic_files do
      column :id, Integer, :serial => true
      column :path, String
      column :assignment_id, Integer
    end

    DataMapper.repository.adapter.execute('INSERT INTO assignment_generic_files(path, assignment_id) SELECT path, assignment_id FROM assignment_files')

    drop_table :assignment_files
  end
end
