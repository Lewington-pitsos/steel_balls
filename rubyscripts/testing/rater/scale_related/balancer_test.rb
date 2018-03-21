require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager/scale/balancer'
require_relative '../../../logic/shared/arrangement_generator/ball_generator'

class BalancerTest < Minitest::Test

  @@normal_balls = BallGenerator.new.generate_balls

  @@weird_balls = BallGenerator
    .new
    .generate_balls
    .each { |ball| ball.make_heavier  }

  def setup
    @generator = BallGenerator.new()
    @example_categories = {
      balanced: [],
      heavier: @generator.generate_balls(2),
      lighter: @generator.generate_balls(2),
      unweighed: @generator.generate_balls(4)
    }

    @weird_categories = {
      balanced: [],
      heavier: @generator.generate_balls(9),
      lighter: @generator.generate_balls(1),
      unweighed: @generator.generate_balls(40)
    }
    @balancer = Balancer.new()
  end

  def test_agglomorates_correctly
    array = @balancer.send(:agglomorate, @example_categories)
    assert_equal 8, array.length

    array = @balancer.send(:agglomorate, @weird_categories)
    assert_equal 50, array.length
  end

  def teardown
  end
end
