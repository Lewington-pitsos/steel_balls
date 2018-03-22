require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_collector/scale_manager/scale/balancer/comparer'
require_relative '../../../logic/shared/arrangement_generator/ball_generator'

class ComparerTest < Minitest::Test

  @@normal_balls = BallGenerator.new.generate_balls

  @@weird_balls = BallGenerator
    .new
    .generate_balls
    .each { |ball| ball.make_heavier  }

  def setup
    @lighter_balls = BallGenerator.new.generate_balls
    @lighter_balls[0].make_lighter
    @comparer = Comparer.new()
  end

  def test_correct_total_weight
    weight = @comparer.send(:total_weight, @@normal_balls)
    assert_equal 8, weight

    weight = @comparer.send(:total_weight, @@weird_balls)
    assert_equal 16, weight

    weight = @comparer.send(:total_weight, @lighter_balls)
    assert_equal 7, weight
  end

  def test_correct_weigh_results
    @comparer.weigh_balls(@@normal_balls, @@weird_balls)

    assert_same @@normal_balls, @comparer.lighter
    assert_same @@weird_balls, @comparer.heavier

    @comparer.weigh_balls(@@normal_balls, @lighter_balls)

    assert_same @@normal_balls, @comparer.heavier
    assert_same @lighter_balls, @comparer.lighter

    new_balls = BallGenerator.new.generate_balls

    @comparer.weigh_balls(@@normal_balls, new_balls)

    @@normal_balls.each do |ball|
      assert @comparer.balanced.include?(ball)
    end

    new_balls.each do |ball|
      assert @comparer.balanced.include?(ball)
    end
  end

  def test_resets_results
    @comparer.weigh_balls(@@weird_balls, @lighter_balls)

    refute_empty @comparer.lighter
    refute_empty @comparer.heavier

    @comparer.weigh_balls(@lighter_balls, @lighter_balls)

    assert_empty @comparer.heavier
    assert_empty @comparer.lighter
  end

  def teardown
  end
end
