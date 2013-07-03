migration 12, :add_tag_to_account do
  up do
    modify_table :accounts do
      add_column :tag, String
    end
  end

  down do
    modify_table :accounts do
      drop_column :tag
    end
  end
end
