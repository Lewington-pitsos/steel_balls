require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require_relative '../../logic/database/selection_recorder'
require 'pg'

class SelectionRecorderTest < Minitest::Test

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
    @db = PG.connect({ dbname: $DATABASE_NAME, user: 'postgres' })
    @setup = Setup.new($DATABASE_NAME)
    @setup.suppress_warnings
    @setup.send(:clear_database)
    @setup.setup_if_needed
    @recorder = SelectionRecorder.new($DATABASE_NAME)
  end

  def saves_single_state
    @recorder.send(:save_side, @@example_side)

    p @db.exec(@@get_all_sides)
  end

  def teardown
    @setup.send(:clear_database)
    @setup.close()
  end
end
