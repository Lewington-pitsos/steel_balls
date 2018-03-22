require "minitest/autorun"
require_relative '../../logic/database/selection_recorder'
require_relative '../../logic/database/setup'
require 'pg'

class SelectionRecorderTest < Minitest::Test

  @@databse_name = 'test_steel_balls'

  @@example_side = {
    unknown: 0,
    possibly_heavier: 1,
    possibly_lighter: 2,
    normal: 1
  }

  @@get_all_sides = <<~CMD
    SELECT * FROM selection_sides;
  CMD

  def setup
    @db = PG.connect({ dbname: @@databse_name, user: 'postgres' })
    @setup = Setup.new(@@databse_name)
    @setup.suppress_warnings
    @setup.send(:clear_database)
    @setup.setup_if_needed
    @recorder = SelectionRecorder.new(@@databse_name)
  end

  def test_saves_single_state
    @recorder.send(:save_side, @@example_side)

    p @db.exec(@@get_all_sides)
  end

  def teardown
    @setup.send(:clear_database)
  end
end
