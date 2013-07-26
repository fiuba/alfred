migration 16, :add_test_result_to_solution do
  up do
    modify_table :solutions do
      add_column :test_result, String
    end
  end

  down do
    modify_table :solutions do
      drop_column :test_result
    end
  end
end
