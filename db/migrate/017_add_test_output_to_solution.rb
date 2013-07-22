migration 17, :add_test_output_to_solution do
  up do
    modify_table :solutions do
      add_column :test_output, String
    end
  end

  down do
    modify_table :solutions do
      drop_column :test_output
    end
  end
end
