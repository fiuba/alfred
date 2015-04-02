migration 24, :add_is_blocking_to_assignment do
  up do
    modify_table :assignments do
      add_column :is_blocking, "BOOLEAN"
    end
  end

  down do
    modify_table :assignments do
      drop_column :is_blocking
    end
  end
end
