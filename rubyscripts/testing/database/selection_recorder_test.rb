require "minitest/autorun"
require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/selection_recorder'

class SelectionRecorderTest < DatabaseTester

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
    setup_database_for_testing
    @recorder = SelectionRecorder.new($DATABASE_NAME)
  end

  def saves_single_state
    @recorder.send(:save_side, @@example_side)

    p @db.exec(@@get_all_sides)
  end

  def teardown
    teardown_database
  end
end
