require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager/scale/weigh_executer'
require_relative '../../../logic/state_evaluator/selection_overseer/all_arrangements/state_expander'

require_relative '../../../logic/shared/arrangement_generator/ball'

class WeighExecutorTest < Minitest::Test

  @@basic_balance_state = {

  }

  def setup
    @generator = BallGenerator.new()
    @example_balance_state = {
      balanced: [],
      heavier: @generator.generate_balls(2),
      lighter: @generator.generate_balls(2),
      unweighed: @generator.generate_balls(4)
    }

    @balanced_balance_state = {
      balanced: @generator.generate_balls(4),
      heavier: [],
      lighter: [],
      unweighed: @generator.generate_balls(4)
    }

    heavier = @generator.generate_balls(4).each do |ball|
      ball.mark = :possibly_lighter
    end

    lighter = @generator.generate_balls(4)

    lighter[0].mark == :possibly_heavier

    unweighed = @generator.generate_balls(4).each do |ball|
      ball.mark = :possibly_lighter
    end

    @marked_balance_state = {
      balanced: [],
      heavier: heavier,
      lighter: lighter,
      unweighed: unweighed
    }

    @unknown_ball = Ball.new()
    @normal_ball = Ball.new(:normal)
    @lighter_ball = Ball.new(:possibly_lighter)
    @heavier_ball = Ball.new(:possibly_heavier)

    @executor= WeighExecutor.new()
  end

  def test_recognized_balanced_states
    @executor.send(:balance_state=, @example_balance_state)
    refute @executor.send(:balanced?)

    @executor.send(:balance_state=, @balanced_balance_state)
    assert @executor.send(:balanced?)

    @executor.send(:balance_state=, @marked_balance_state)
    refute @executor.send(:balanced?)
  end

  def test_mark_updating_correctly
    @executor.send(:update_mark, @normal_ball, :possibly_heavier)

    assert_equal :normal, @normal_ball.mark

    @executor.send(:update_mark, @heavier_ball, :possibly_heavier)

    assert_equal :possibly_heavier, @heavier_ball.mark

    @executor.send(:update_mark, @lighter_ball, :possibly_lighter)

    assert_equal :possibly_lighter, @lighter_ball.mark

    @executor.send(:update_mark, @lighter_ball, :possibly_heavier)

    assert_equal :normal, @lighter_ball.mark

    @executor.send(:update_mark, @heavier_ball, :possibly_lighter)

    assert_equal :normal, @heavier_ball.mark

    @executor.send(:update_mark, @unknown_ball, :possibly_lighter)

    assert_equal :possibly_lighter, @unknown_ball.mark
  end

  def test_normalizing_works
    heavier = @generator.generate_balls(4).each do |ball|
      ball.mark = :possibly_lighter
    end
    @executor.send(:normalize, heavier)

    heavier.each do |ball|
      assert_equal :normal ball.mark
    end
  end

  def test_weighing_produces_expected_results
    @executor.execute_weigh(@example_balance_state)
  end

  def teardown
  end
end
