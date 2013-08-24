migration 6, :add_assignment_id_to_solution do
  up do
    modify_table :solutions do
      add_column :assignment_id, Integer
    end
  end

  down do
    modify_table :solutions do
      drop_column :assignment_id
    end
  end
end
