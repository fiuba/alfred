migration 10, :create_solution_generic_file do
  up do
  	create_table :solution_generic_files do
      column :id, Integer, :serial => true
      column :commments, String
      column :path, String
      column :solution_id, Integer
    end
  end

  down do
    drop_table :solution_generic_files
  end
end
