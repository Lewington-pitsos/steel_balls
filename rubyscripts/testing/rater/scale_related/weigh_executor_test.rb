require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager/scale/weigh_executer'
require_relative '../../../logic/state_evaluator/selection_overseer/all_arrangements/state_expander'

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



    @executor= WeighExecutor.new()
  end

  def teardown
  end
end
