migration 27, :add_correction_template_to_assignments do
  up do
    modify_table :assignments do
      add_column :correction_template, String
    end
  end

  down do
  end
end
