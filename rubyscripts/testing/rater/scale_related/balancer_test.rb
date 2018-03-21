require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager/scale/balancer'
require_relative '../../../logic/shared/arrangement_generator/ball_generator'

class BalancerTest < Minitest::Test

  @@normal_balls = BallGenerator.new.generate_balls

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

    @marked_balls = @generator.generate_balls()
    @marked_balls[0].mark = :normal
    @marked_balls[1].mark = :normal

    @marked_balls[2].mark = :possibly_lighter

    @marked_balls[3].mark = :possibly_heavier
    @marked_balls[4].mark = :possibly_heavier
    @marked_balls[5].mark = :possibly_heavier

    @balancer = Balancer.new()
  end

  def test_agglomorates_correctly
    array = @balancer.send(:agglomorate, @example_categories)
    assert_equal 8, array.length

    array = @balancer.send(:agglomorate, @weird_categories)
    assert_equal 50, array.length
  end

  def test_categorizes_balls_correctly
    @balancer.send(:balls=, @@normal_balls)
    @balancer.send(:categorize_balls)
    categories = @balancer.send(:categories)

    assert_equal 8, categories[:unknown].length
    assert_empty categories[:normal]
    assert_empty categories[:possibly_lighter]
    assert_empty categories[:possibly_heavier]

    @balancer.send(:balls=, @marked_balls)
    @balancer.send(:categorize_balls)
    categories = @balancer.send(:categories)

    assert_equal 2, categories[:unknown].length
    assert_equal 2, categories[:normal].length
    assert_equal 1, categories[:possibly_lighter].length
    assert_equal 3, categories[:possibly_heavier].length
  end

  def teardown
  end
end
