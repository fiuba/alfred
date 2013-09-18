migration 20, :modify_public_private_comments_for_correction do
  up do
     DataMapper.repository.adapter.execute(                                   \
       'ALTER TABLE "corrections" ALTER COLUMN "public_comments" TYPE text'   \
     )

     DataMapper.repository.adapter.execute(                                   \
       'ALTER TABLE "corrections" ALTER COLUMN "private_comments" TYPE text'  \
     )
  end

  down do
     DataMapper.repository.adapter.execute(                                           \
       'ALTER TABLE "corrections" ALTER COLUMN "public_comments" TYPE VARCHAR(255)'   \
     )

     DataMapper.repository.adapter.execute(                                           \
       'ALTER TABLE "corrections" ALTER COLUMN "private_comments" TYPE VARCHAR(255)'  \
     )
  end
end
