require "minitest/autorun"
require_relative '../logic/all_arrangements/arrangement_expander'
require_relative '../logic/shared/arrangement_generator'

class ArrangementExpanderTest < Minitest::Test

  def setup
    @arr_expander = ArrangementExpander.new()
    @arr_generator = ArrangementGenerator.new()
  end

  def test_deafult_setting
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
