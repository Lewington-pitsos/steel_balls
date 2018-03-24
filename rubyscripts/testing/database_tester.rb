require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require_relative '../../logic/database/setup'

class DatabaseTester < Minitest::Test

  def setup_database_for_testing
    @setup = Setup.new($DATABASE_NAME)
    @setup.suppress_warnings
    @setup.send(:clear_database)
    @setup.setup_if_needed
  end


  def teardown_database
    @setup.send(:clear_database)
    @setup.close()
  end

end
