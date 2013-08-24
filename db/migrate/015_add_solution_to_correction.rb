migration 15, :add_solution_to_correction do
  up do
    modify_table :corrections do
      add_column :solution_id, Integer
    end
  end

  down do
    modify_table :corrections do
      drop_column :solution_id
    end
  end
end
