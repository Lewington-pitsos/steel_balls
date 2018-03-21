require "minitest/autorun"
require_relative '../logic/state_evaluator/selection_overseer/all_arrangements/state_expander'

class StateExpanderTest < Minitest::Test

  @@small_state = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@medium_state = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@basic_state = {
    unknown: 8,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@light_state = {
    unknown: 3,
    possibly_heavier: 0,
    possibly_lighter: 1,
    normal: 0
  }

  @@normal_state = {
    unknown: 0,
    possibly_heavier: 0,
    possibly_lighter: 1,
    normal: 3
  }

  def setup
    @arr_expander = StateExpander.new()
  end

  def test_class_weights
    assert_equal :heavier, StateExpander.weights
    StateExpander.weights = :both
    assert_equal :both, StateExpander.weights
  end

  def test_default_weights
    assert_equal :both, @arr_expander.weights
    StateExpander.weights = :heavier
    new_expander = StateExpander.new()
    assert_equal :heavier, new_expander.weights
  end

  def test_picks_out_alterable_balls
    ball = Ball.new()
    assert @arr_expander.send(:alter_able?, ball, :heavier)

    ball.mark = :normal
    refute @arr_expander.send(:alter_able?, ball, :heavier)

    ball.mark = :possibly_lighter
    refute @arr_expander.send(:alter_able?, ball, :heavier)
  end

  def test_generates_correct_arrangements
    all_possible_arrangements = @arr_expander.expand(@@small_state)
    assert_equal 2, all_possible_arrangements.length

    all_possible_arrangements = @arr_expander.expand(@@medium_state)
    assert_equal 4, all_possible_arrangements.length

    StateExpander.weights = :both
    new_expander = StateExpander.new()
    all_possible_arrangements = new_expander.expand(@@medium_state)
    assert_equal 8, all_possible_arrangements.length
  end

  def test_takes_ball_markings_into_account
    all_possible_arrangements = @arr_expander.expand(@@light_state)
    assert_equal 3, all_possible_arrangements.length

    StateExpander.weights = :both
    new_expander = StateExpander.new()
    all_possible_arrangements = new_expander.expand(@@normal_state)
    assert_equal 1, all_possible_arrangements.length
  end


  def teardown
    StateExpander.weights = :heavier
  end

end
