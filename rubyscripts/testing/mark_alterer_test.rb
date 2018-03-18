require "minitest/autorun"
require_relative '../logic/shared/ball'
require_relative '../logic/shared/mark_changer'
require_relative '../logic/shared/arrangement_generator'

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

  def setup
    @mark_changer = MarkChanger.new()
    @arr_generator = ArrangementGenerator.new()
  end

  def test_state_can_be_set
    assert_equal @@basic_state.to_s, @mark_changer.state.to_s
    @mark_changer.state = @@sample_state
    assert_equal @@sample_state.to_s, @mark_changer.state.to_s
  end

  def test_changes_marks_correctly
    balls = @arr_generator.generate_balls()
    marked_balls = @mark_changer.marked_balls(balls, state)

    assert_equal 4, marked_balls.count { |ball| ball.mark == :unknown }
    assert_equal 2, marked_balls.count { |ball| ball.mark == :possibly_heavier }
    assert_equal 2, marked_balls.count { |ball| ball.mark == :possibly_lighter }
  end


  def teardown
  end
end
