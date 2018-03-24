require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/database/setup'
require 'pg'

class DatabaseTester < Minitest::Test

  def setup_database_for_testing
    @db = PG.connect({ dbname: $DATABASE_NAME, user: 'postgres' })
    @setup = Setup.new($DATABASE_NAME)
    @setup.suppress_warnings
    @setup.send(:clear_database)
    @setup.setup_if_needed
  end

  def add_defaults
    @setup.add_default_states
  end

  def teardown_database
    @setup.send(:clear_database)
    @setup.close()
    @db.close()
  end

  def get_all(relation)
    @db.exec(
      <<~CMD
        SELECT * FROM #{relation};
      CMD
    )
  end

end
