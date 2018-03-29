require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/state_evaluator/selection_overseer/state_expander/arrangement_generator/mark_changer'

class MarkChangerTest < Minitest::Test
  @@basic_state = {
    unknown: 8,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@sample_state = {
    unknown: 4,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 0
  }

  @@small_state = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@big_state = {
    unknown: 12,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  def setup
    @mark_changer = MarkChanger.new()
    @arr_generator = BallGenerator.new()
  end

  def test_state_can_be_set
    assert_equal @@basic_state.to_s, @mark_changer.state.to_s
    @mark_changer.state = @@sample_state
    assert_equal @@sample_state.to_s, @mark_changer.state.to_s
  end

  def test_changes_marks_correctly
    @mark_changer.state = @@sample_state
    balls = @arr_generator.generate_balls()
    marked_balls = @mark_changer.marked_balls(balls)

    assert_equal 8, marked_balls.length
    assert_equal 4, marked_balls.count { |ball| ball.mark == :unknown }
    assert_equal 2, marked_balls.count { |ball| ball.mark == :possibly_heavier }
    assert_equal 2, marked_balls.count { |ball| ball.mark == :possibly_lighter }
  end

  def test_state_can_be_passed_in
    balls = @arr_generator.generate_balls()
    marked_balls = @mark_changer.marked_balls(balls, @@sample_state)

    assert_equal 8, marked_balls.length
    assert_equal 4, marked_balls.count { |ball| ball.mark == :unknown }
    assert_equal 2, marked_balls.count { |ball| ball.mark == :possibly_heavier }
    assert_equal 2, marked_balls.count { |ball| ball.mark == :possibly_lighter }


    balls = @arr_generator.generate_balls(4)
    marked_balls = @mark_changer.marked_balls(balls, @@small_state)

    assert_equal 4, marked_balls.length
    assert_equal 4, marked_balls.count { |ball| ball.mark == :unknown }
    assert_equal 0, marked_balls.count { |ball| ball.mark == :possibly_heavier }
    assert_equal 0, marked_balls.count { |ball| ball.mark == :possibly_lighter }

    balls = @arr_generator.generate_balls(12)
    marked_balls = @mark_changer.marked_balls(balls, @@small_state)

    assert_equal 12, marked_balls.length
    assert_equal 12, marked_balls.count { |ball| ball.mark == :unknown }
    assert_equal 0, marked_balls.count { |ball| ball.mark == :possibly_heavier }
    assert_equal 0, marked_balls.count { |ball| ball.mark == :possibly_lighter }
  end


  def teardown
  end
end
