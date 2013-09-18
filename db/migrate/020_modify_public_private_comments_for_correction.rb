migration 20, :modify_public_private_comments_for_correction do
  up do
    if DataMapper.repository.adapter.class.to_s =~ /DataMapper::Adapters::SqliteAdapter/i
      drop_table :corrections

      create_table :corrections do
        column :id, Integer, :serial => true
        column :public_comments, Text
        column :private_comments, Text
        column :grade, Float
      	column :created_at, DateTime  
        column :updated_at, DateTime
      end
    else
      DataMapper.repository.adapter.execute(                                   \
        'ALTER TABLE "corrections" ALTER COLUMN "public_comments" TYPE text'   \
      )
     
      DataMapper.repository.adapter.execute(                                   \
        'ALTER TABLE "corrections" ALTER COLUMN "private_comments" TYPE text'  \
      )
    end
  end

  down do
    if DataMapper.repository.adapter.class.to_s =~ /DataMapper::Adapters::SqliteAdapter/i
      drop_table :corrections

    create_table :corrections do
      column :id, Integer, :serial => true
      column :public_comments, String
      column :private_comments, String
      column :grade, Float
    	column :created_at, DateTime  
      column :updated_at, DateTime
    end
    else
      DataMapper.repository.adapter.execute(                                           \
        'ALTER TABLE "corrections" ALTER COLUMN "public_comments" TYPE VARCHAR(255)'   \
      )
     
      DataMapper.repository.adapter.execute(                                           \
        'ALTER TABLE "corrections" ALTER COLUMN "private_comments" TYPE VARCHAR(255)'  \
      )
    end
  end
end
