require "minitest/autorun"
require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/state_manager'

class StateManagerTest < DatabaseTester

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
      unknown: 3,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }

  @@state4 ={
    state: {
      unknown: 4,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }

  @@state5 ={
    state: {
      unknown: 5,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }

  @@state7 ={
    state: {
      unknown: 7,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }

  @@state12 ={
    state: {
      unknown: 12,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }



  def setup
    setup_database_for_testing
    add_defaults
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

  def scores_states_correctly
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
    $WINNING_RATING = 12
    $DEFAULT_LENGTH = 3
    manager = StateManager.new(@@small_state)
    assert_equal 2, manager.score

    $WINNING_RATING = 17
    $DEFAULT_LENGTH = 4
    manager = StateManager.new(@@state4)
    assert_equal 3, manager.score

    $WINNING_RATING = 22
    $DEFAULT_LENGTH = 5
    manager = StateManager.new(@@state5)
    assert_equal 3, manager.score

    $WINNING_RATING = 32
    $DEFAULT_LENGTH = 7
    manager = StateManager.new(@@state7)
    assert_equal 3, manager.score

    # $WINNING_RATING = 57
    # $DEFAULT_LENGTH = 12
    # manager = StateManager.new(@@state12)
    # assert_equal 3, manager.score


    $WINNING_RATING = 37
    $DEFAULT_LENGTH = 8
  end

  def teardown
    teardown_database
  end
end
