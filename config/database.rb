##
# A MySQL connection:
# DataMapper.setup(:default, 'mysql://user:password@localhost/the_database_name')
#
# # A Postgres connection:
# DataMapper.setup(:default, 'postgres://user:password@localhost/the_database_name')
#
# # A Sqlite3 connection
# DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "development.db"))
#

DataMapper.logger = logger
DataMapper::Logger.new($stdout, :debug)
DataMapper::Property::String.length(255)

case Padrino.env
  when :development then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "alfred_development.db"))
  when :test        then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "alfred_test.db"))
  when :travis      then DataMapper.setup(:default, "sqlite3://" + Padrino.root('db', "alfred_travis.db"))
 	when :staging 		then DataMapper.setup(:default, ENV['DATABASE_URL'])
  when :production  then DataMapper.setup(:default, ENV['DATABASE_URL'])
end
