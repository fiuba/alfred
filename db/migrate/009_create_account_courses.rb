migration 9, :create_account_courses do
  up do
  	create_table :account_courses do
      column :account_id, Integer
      column :course_id, Integer
    end
  end

  down do
  	drop_table :account_courses
  end
end
