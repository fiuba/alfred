migration 4, :create_solutions do
  up do
    create_table :solutions do
      column :id, Integer, :serial => true
      column :comments, String
      column :file, String, :length => 255
    end
  end

  down do
    drop_table :solutions
  end
end
