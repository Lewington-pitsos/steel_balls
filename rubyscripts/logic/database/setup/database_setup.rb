# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.
require 'pg'
require_relative '../setup'

class DatabaseSetup < Setup


  def initialize(name=$DATABASE_NAME)
    super(name)
    try_to_connect
  end

  def try_to_connect
    begin
      spin_up
    rescue
      create_database
      spin_up
    end

    unless @db
      puts "ERROR: Could not create #{@name} database"
    end
  end

  def try_dropping
    begin
      teardown_database
    rescue
      true
    end
  end

  private

  attr_accessor :db, :name

  def spin_up
    @db = PG.connect({ dbname: @name, user: 'postgres' })
  end

  def create_database
    db = PG.connect({ dbname: 'postgres', user: 'postgres' })
    db.exec("CREATE DATABASE #{@name};")
    db.finish()
  end

  def teardown_database
    @db.finish()
    closing_db = PG.connect({ dbname: 'postgres', user: 'postgres' })
    closing_db.exec("DROP DATABASE #{@name};")
    closing_db.finish()
  end
end
