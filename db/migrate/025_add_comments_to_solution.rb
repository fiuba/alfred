migration 25, :add_comments_to_solution do
  up do
    modify_table :solutions do
      add_column :comments, String
    end
  end

  down do
    modify_table :solutions do
      drop_column :comments
    end
  end
end
