migration 2, :create_accounts do
  up do
    create_table :accounts do
      column :id, Integer, :serial => true
      column :name, String, :length => 255
      column :email, String, :length => 255
      column :uid, String, :length => 255
      column :provider, String, :length => 255
    end
  end

  down do
    drop_table :accounts
  end
end
