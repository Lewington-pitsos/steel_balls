require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require_relative '../../logic/database/setup'

class InfoMinerTest < Minitest::Test

  @@databse_name = 'test_steel_balls'

  def setup
    @setup = Setup.new($DATABASE_NAME)
    @setup.setup_if_needed
  end

  def teardown
    @setup.send(:clear_database)
  end
end
