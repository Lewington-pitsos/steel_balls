require "minitest/autorun"
require './rubyscripts/testing/database_tester'
require_relative '../logic/state_evaluator'

class StateEvaluatorTest < DatabaseTester

  @@almost_winning_state = {
    unknown: 0,
    possibly_heavier: 1,
    possibly_lighter: 1,
    normal: 6
  }

  @@almost_winning_state2 = {
    unknown: 0,
    possibly_heavier: 1,
    possibly_lighter: 2,
    normal: 5
  }

  @@non_winning_state = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 4
  }



  def setup
    setup_database_for_testing
    add_defaults(@@almost_winning_state, @@almost_winning_state2, @@non_winning_state)
  end

  def test_scores_states_correctly
    manager = StateEvaluator.new(@@almost_winning_state, 34)
    assert_equal 1, manager.state_score
    manager = StateEvaluator.new(@@almost_winning_state2, 32)
    assert_equal 1, manager.state_score
    manager = StateEvaluator.new(@@non_winning_state, 20)
    assert_equal 2, manager.state_score
  end

  def teardown
    teardown_database
  end
end
