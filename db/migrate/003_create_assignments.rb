migration 3, :create_assignments do
  up do
    create_table :assignments do
      column :id, Integer, :serial => true
      column :name, String, :length => 255
      column :files, String, :length => 255
      column :test_script, String, :length => 255
      column :deadline, DateTime
    end
  end

  down do
    drop_table :assignments
  end
end
