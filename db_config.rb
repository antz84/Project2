require 'active_record'

options = {
  adapter: 'postgresql',
  database: 'dearsanta',
}

ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
