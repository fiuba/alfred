migration 11, :add_created_at_to_solution do
  up do
    modify_table :solutions do
      add_column :created_at, DateTime
    end
  end

  down do
    modify_table :solutions do
      drop_column :created_at
    end
  end
end
