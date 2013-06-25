migration 8, :update_assignments do
  up do
  	# Sqlite doesn't support ALTERing tables to remove columns
  	if DataMapper.repository.adapter.class == DataMapper::Adapters::SqliteAdapter
	  	drop_table :assignments

	  	create_table :assignments do
	      column :id, Integer, :serial => true
	      column :name, String, :length => 255
	      column :test_script, String, :length => 255
	      column :deadline, DateTime
	      column :course_id, Integer
	    end
	  else
	    modify_table :assignments do
	      drop_column :files
	    end
	  end
  end

  down do
  	# Sqlite doesn't support ALTERing tables to remove columns
  	if DataMapper.repository.adapter.class == DataMapper::Adapters::SqliteAdapter
	  	drop_table :assignments

	  	create_table :assignments do
	      column :id, Integer, :serial => true
	      column :name, String, :length => 255
	      column :files, String, :length => 255
	      column :test_script, String, :length => 255
	      column :deadline, DateTime
	      column :course_id, Integer
	    end
	  else
	  	modify_table :assignments do
	      add_column :files, String
	    end
	 	end
  end
end
