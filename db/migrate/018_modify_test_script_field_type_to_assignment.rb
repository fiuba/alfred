migration 18, :modify_test_script_field_type_to_assignment do
  up do
    # Sqlite doesn't support ALTERing tables to remove columns
    if DataMapper.repository.adapter.class.to_s =~ /DataMapper::Adapters::SqliteAdapter/i
      drop_table :assignments

      create_table :assignments do
        column :id, Integer, :serial => true
        column :name, String, :length => 255
        column :files, String, :length => 255
        column :test_script, DataMapper::Property::Text
        column :deadline, DateTime
        column :course_id, Integer
      end
    else
      modify_table :assignments do
        change_column :test_script, 'text'
      end
    end
  end

  down do
    # Sqlite doesn't support ALTERing tables to remove columns
    if DataMapper.repository.adapter.class.to_s =~ /DataMapper::Adapters::SqliteAdapter/i
      drop_table :assignments

      create_table :assignments do
        column :id, Integer, :serial => true
        column :name, String, :length => 255
        column :files, String, :length => 255
        column :test_script, DataMapper::Property::Text
        column :deadline, DateTime
        column :course_id, Integer
      end
    else
      modify_table :assignments do
        change_column :test_script, 'text'
      end
    end
  end
end
