migration 21, :create_karmas do
  up do
    create_table :karmas do
      column :id, Integer, :serial => true
      column :value, Integer
      column :description, String, :length => 255
      column :student_id, Integer
      column :course_id, Integer
      column :created_at, DateTime
    end
  end

  down do
    drop_table :karmas
  end
end
