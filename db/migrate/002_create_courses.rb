migration 2, :create_courses do
  up do
    create_table :courses do
      column :id, Integer, :serial => true
      column :name, String, :length => 255
      column :active, "BOOLEAN"
    end
  end

  down do
    drop_table :courses
  end
end
