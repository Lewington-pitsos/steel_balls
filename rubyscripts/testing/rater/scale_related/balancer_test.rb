require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager/scale/balancer'
require_relative '../../../logic/shared/arrangement_generator/ball_generator'

class BalancerTest < Minitest::Test

  @@basic_state = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@small_state = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@weird_state = {
    unknown: 1,
    possibly_heavier: 3,
    possibly_lighter: 1,
    normal: 2
  }

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

  def test_gathers_balls_correctly
    @balancer.send(:balls=, @@normal_balls)
    @balancer.send(:categorize_balls)
    to_weigh = @balancer.send(:gather_balls, @@basic_state)


    assert_equal 4, to_weigh.length
    to_weigh.each do |ball|
      assert_equal :unknown, ball.mark
    end

    @balancer.send(:balls=, @marked_balls)
    @balancer.send(:categorize_balls)
    to_weigh = @balancer.send(:gather_balls, @@weird_state)

    assert_equal 7, to_weigh.length
    assert_equal 3, to_weigh.count { |b| b.mark == :possibly_heavier }
    assert_equal 1, to_weigh.count { |b| b.mark == :possibly_lighter }
    assert_equal 1, to_weigh.count { |b| b.mark == :unknown }
    assert_equal 2, to_weigh.count { |b| b.mark == :normal }
  end

  def test_balls_removed_from_categories_when_targeted_for_weigh
    @balancer.send(:balls=, @@normal_balls)
    @balancer.send(:categorize_balls)
    to_weigh = @balancer.send(:gather_balls, @@basic_state)
    to_weigh2 = @balancer.send(:gather_balls, @@basic_state)

    leftovers = @balancer.send(:agglomorate, @balancer.send(:categories))

    to_weigh.each do |ball|
      refute to_weigh2.include?(ball)
      refute leftovers.include?(ball)
    end

    to_weigh2.each do |ball|
      refute leftovers.include?(ball)
    end
  end

  def test_accurate_balance_state_returned
    selection_order =  {
      left: {
        unknown: 1,
        possibly_heavier: 0,
        possibly_lighter: 0,
        normal: 1
      },
      right: {
        unknown: 0,
        possibly_heavier: 2,
        possibly_lighter: 0,
        normal: 0
      }
    }

    @balancer.balance(selection_order, @marked_balls)

    assert_equal 4, @balancer.balance_state[:unweighed].length
    assert_equal 4, @balancer.balance_state[:balanced].length
    assert_empty @balancer.balance_state[:heavier]
    assert_empty @balancer.balance_state[:lighter]

    ball = @marked_balls[5]

    ball.make_lighter

    @balancer.balance(selection_order, @marked_balls)
    assert_equal 4, @balancer.balance_state[:unweighed].length
    assert_equal 2, @balancer.balance_state[:heavier].length
    assert_equal 2, @balancer.balance_state[:lighter].length
    assert_empty @balancer.balance_state[:balanced]

  end

  def teardown
  end
end
