migration 5, :add_account_id_to_solution do
  up do
    modify_table :solutions do
      add_column :account_id, Integer
    end
  end

  down do
    modify_table :solutions do
      drop_column :account_id
    end
  end
end
