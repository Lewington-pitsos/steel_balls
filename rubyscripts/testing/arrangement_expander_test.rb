require "minitest/autorun"
require_relative '../logic/all_arrangements/arrangement_expander'
require_relative '../logic/shared/arrangement_generator'

class ArrangementExpanderTest < Minitest::Test

  def setup
    @arr_expander = ArrangementExpander.new()
    @arr_generator = ArrangementGenerator.new()
  end

  def test_class_weights
    assert_equal :heavier, ArrangementExpander.weights
    ArrangementExpander.weights = :both
    assert_equal :both, ArrangementExpander.weights
  end

  def test_default_weights
    assert_equal :heavier, @arr_expander.weights
    ArrangementExpander.weights = :both
    new_expander = ArrangementExpander.new()
    assert_equal :both, new_expander.weights
  end

  def test_generates_correct_arrangements
    balls = @arr_generator.generate_balls(2)
    all_possible_arrangements = @arr_expander.expand(balls)
    assert_equal 2, all_possible_arrangements.length

    balls = @arr_generator.generate_balls(4)
    all_possible_arrangements = @arr_expander.expand(balls)
    assert_equal 4, all_possible_arrangements.length

    ArrangementExpander.weights = :both
    new_expander = ArrangementExpander.new()
    balls = @arr_generator.generate_balls(4)
    all_possible_arrangements = new_expander.expand(balls)
    assert_equal 8, all_possible_arrangements.length
  end

  def test_takes_ball_markings_into_account
    balls = @gen.generate_balls(4)
    balls[0].mark = :possibly_lighter
    all_possible_arrangements = @arr_expander.expand(balls)
    assert_equal 1, all_possible_arrangements.length

    ArrangementExpander.weights = :both
    new_expander = ArrangementExpander.new()
    balls = @arr_generator.generate_balls(4)
    balls.each { |ball| ball.mark = :normal }
    balls[0].mark = :possibly_heavier
    all_possible_arrangements = new_expander.expand(balls)
    assert_equal 1, all_possible_arrangements.length
  end


  def teardown
  end

end
