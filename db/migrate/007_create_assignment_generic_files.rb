migration 7, :create_assignment_generic_files do
  up do
  	create_table :assignment_generic_files do
      column :id, Integer, :serial => true
      column :path, String
      column :assignment_id, Integer
    end
  end

  down do
    drop_table :assignment_generic_files
  end
end
