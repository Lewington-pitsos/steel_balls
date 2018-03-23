# this is a superlcass for all classes that interact with the database
require 'pg'


class Archivist

  @@database_name = 'steel_balls'

  def self.set_db_name(name)
    @@database_name = name
  end

  def initialize(name=@@database_name)
    @db = PG.connect({ dbname: name, user: 'postgres' })
  end


  def close
    @db.finish()
  end

  private

  attr_accessor :db

end
