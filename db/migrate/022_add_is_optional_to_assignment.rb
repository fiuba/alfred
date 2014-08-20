migration 22, :add_is_optional_to_assignment do
  up do
    modify_table :assignments do
      add_column :is_optional, "BOOLEAN"
    end
  end

  down do
    modify_table :assignments do
      drop_column :is_optional
    end
  end
end
