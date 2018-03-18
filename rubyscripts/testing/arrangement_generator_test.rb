require "minitest/autorun"
require_relative '../logic/shared/arrangement_generator'

class ArrangementGeneratorTest < Minitest::Test

  @@sample_state = {
    unknown: 4,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 0
  }

  @@sample_state2 = {
    unknown: 2,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 8
  }

  @@sample_state3 = {
    unknown: 0,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  def setup
    @arrangement_generator = ArrangementGenerator.new()
  end

  def test_works_out_state_length
    length = @arrangement_generator.send(:get_length, @@sample_state)
    assert_equal 8, length

    length = @arrangement_generator.send(:get_length, @@sample_state2)
    assert_equal 14, length

    length = @arrangement_generator.send(:get_length, @@sample_state3)
    assert_equal 0, length
  end

  def test_generated_arrangments_match_state
    balls = @arrangement_generator.marked_balls(@@sample_state)

    @@sample_state.each do |mark, num|
      assert_equal num, balls.count { |ball| ball.mark == mark }
    end
  end

  def teardown
  end
end
