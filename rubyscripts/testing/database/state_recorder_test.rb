require "minitest/autorun"
require_relative '../../logic/database/state_recorder'
require_relative '../../logic/database/setup'

class StateRecorderTest < Minitest::Test

  @@databse_name = 'test_steel_balls'

  def setup
    @setup = Setup.new(@@databse_name)
    @setup.setup_if_needed
    @archivist = StateRecorder.new(@@databse_name)
  end

  def teardown
    @setup.send(:clear_database)
  end
end
