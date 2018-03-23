require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require_relative '../../logic/database/state_recorder'
require_relative '../../logic/database/score_checker'

class ScoreCheckerTest < Minitest::Test
  @@example_state = {
    state: {
      unknown: 4,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    state_score: 29,
    selections: []
  }

  @@just_state = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@example_state2 = {
    state: {
      unknown: 2,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 2
    },
    state_score: 25,
    selections: []
  }

  @@just_state2 = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 2
  }

  @@new_state = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@new_state2 = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 2
  }


  @@database_name = 'test_steel_balls'

  def setup
    @setup = Setup.new($DATABASE_NAME)
    @setup.suppress_warnings
    @setup.send(:clear_database)
    @setup.setup_if_needed

    @recorder = StateRecorder.new($DATABASE_NAME)
    @recorder.send(:save_state, @@example_state)
    @recorder.send(:save_state, @@example_state2)
    @recorder.close()

    @checker = ScoreChecker.new($DATABASE_NAME)
  end

  def test_finds_scores_of_existing_balls
    @checker.send(:get_recorded_score, @@just_state)
    assert_equal 1, @checker.send(:score).ntuples
    @checker.send(:get_recorded_score, @@just_state2)
    assert_equal 1, @checker.send(:score).ntuples
  end

  def test_handles_non_existant_balls
    @checker.send(:get_recorded_score, @@new_state)
    assert_equal 0, @checker.send(:score).ntuples
    @checker.send(:get_recorded_score, @@new_state2)
    assert_equal 0, @checker.send(:score).ntuples
  end

  def test_returns_correct_score_values
    assert_equal 29, @checker.recorded_score(@@just_state)
    assert_equal 25, @checker.recorded_score(@@just_state2)
    assert_nil @checker.recorded_score(@@new_state)
    assert_nil @checker.recorded_score(@@new_state2)
  end

  def teardown
    @setup.send(:clear_database)
    @setup.close()
  end
end
