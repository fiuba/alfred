migration 13, :add_correction do
  up do
    create_table :corrections do
      column :id, Integer, :serial => true
      column :public_comments, String
      column :private_comments, String
      column :grade, Float
    	column :created_at, DateTime  
      column :updated_at, DateTime
    end
  end

  down do
    drop_table :corrections
  end
end
