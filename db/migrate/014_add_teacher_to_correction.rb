migration 14, :add_account_to_correction do
  up do
    modify_table :corrections do
      add_column :teacher_id, Integer
    end
  end

  down do
    modify_table :corrections do
      drop_column :teacher_id
    end
  end
end
