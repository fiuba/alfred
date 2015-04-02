migration 26, :support_link_submiting_to_solutions do
  up do
    modify_table :assignments do
      add_column :solution_type, String
    end
    modify_table :solutions do
      add_column :link, String
    end
  end

  down do
    modify_table :assignments do
      drop_column :solution_type
    end
    modify_table :solutions do
      drop_column :link
    end
  end
end
