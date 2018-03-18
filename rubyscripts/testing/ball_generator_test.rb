require "minitest/autorun"
require_relative '../logic/shared/arrangement_generator/ball'
require_relative '../logic/shared/arrangement_generator/ball_generator'

class BallGeneratorTest < Minitest::Test

  def setup
    @gen = BallGenerator.new()
  end

  def test_deafult_length
    assert_equal 8, @gen.length
  end

  def test_generates_default_balls
    balls = @gen.generate_balls()
    assert_equal 8, balls.length
    assert balls[0].mark == :unknown
  end

  def test_generates_different_length_arrays
    balls = @gen.generate_balls(4)
    assert_equal 4, balls.length
  end

  def test_deep_clones_passed_in_ball_array
    balls = @gen.generate_balls(4)
    balls.map { |ball| ball.mark = :normal }
    new_balls = @gen.duplicate_balls(balls)
    new_balls.each_index do |i|
      refute new_balls[i] === balls[i]
      assert new_balls[i].mark == balls[i].mark
    end
  end

  def teardown
  end
end
