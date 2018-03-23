require "minitest/autorun"
require_relative '../logic/state_manager'
require_relative '../logic/database/setup'
require_relative '../logic/database/archivist'

class StateManagerTest < Minitest::Test

  @@database_name = 'test_steel_balls'

  @@winning_state = {
    state: {
      unknown: 0,
      possibly_heavier: 1,
      possibly_lighter: 0,
      normal: 7
    },
    rating: 37
  }

  @@winning_state2 = {
    state: {
      unknown: 0,
      possibly_heavier: 0,
      possibly_lighter: 1,
      normal: 7
    },
    rating: 37
  }

  @@impossible_winning_state = {
    state: {
      unknown: 7,
      possibly_heavier: 0,
      possibly_lighter: 1,
      normal: 0
    },
    rating: 37
  }

  @@almost_winning_state = {
    state: {
      unknown: 0,
      possibly_heavier: 1,
      possibly_lighter: 1,
      normal: 6
    },
    rating: 34
  }

  @@almost_winning_state2 = {
    state: {
      unknown: 0,
      possibly_heavier: 1,
      possibly_lighter: 2,
      normal: 5
    },
    rating: 34
  }

  @@non_winning_state = {
    state: {
      unknown: 4,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 4
    },
    rating: 20
  }

  @@unknown_state = {
    state: {
      unknown: 6,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 2
    },
    rating: 0
  }

  @@hard_state = {
    state: {
      unknown: 8,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }

  @@small_state ={
    state: {
      unknown: 4,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }


  def setup
    Archivist.set_db_name(@@database_name)

    @setup = Setup.new()
    @setup.suppress_warnings
    @setup.send(:clear_database)
    @setup.setup_if_needed
    $WINNING_RATING = 37
    $DEFAULT_LENGTH = 8
  end

  def test_deafult_score_for_winning_states
    manager = StateManager.new(@@winning_state)
    assert_equal 0, manager.score
    manager = StateManager.new(@@winning_state2)
    assert_equal 0, manager.score
    manager = StateManager.new(@@impossible_winning_state)
    assert_equal 0, manager.score
  end

  def test_scores_states_correctly
    manager = StateManager.new(@@almost_winning_state)
    assert_equal 1, manager.score

    manager = StateManager.new(@@almost_winning_state2)
    assert_equal 1, manager.score

    manager = StateManager.new(@@non_winning_state)
    assert_equal 2, manager.score

    manager = StateManager.new(@@unknown_state)
    assert_equal 3, manager.score

    manager = StateManager.new(@@hard_state)
    assert_equal 3, manager.score
  end

  def test_scores_different_sized_states_correctly
    $WINNING_RATING = 17
    $DEFAULT_LENGTH = 4
    manager = StateManager.new(@@small_state)
    assert_equal 2, manager.score
    $WINNING_RATING = 37
    $DEFAULT_LENGTH = 8
  end

  def teardown
    @setup.send(:clear_database)
    @setup.close()
  end
end
