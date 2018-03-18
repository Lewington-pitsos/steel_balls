require "minitest/autorun"
require_relative '../logic/ball'
require_relative '../logic/arrangement_generator'

class ArrangementGeneratorTest < Minitest::Test

  def setup
    @gen = ArrangementGenerator.new()
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


  def teardown
  end
end
