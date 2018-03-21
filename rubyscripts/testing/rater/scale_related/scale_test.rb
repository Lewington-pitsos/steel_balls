require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager/scale'
require_relative '../../../logic/state_evaluator/selection_overseer/all_arrangements/state_expander'

class ScaleTest < Minitest::Test

  @@normal_state = {
    unknown: 2,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 2
  }

  @@normal_selection = {
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
    },
    balls: StateExpander.new.expand(@@normal_state)
  }

  def setup
    @lighter_balls = BallGenerator.new.generate_balls
    @lighter_balls[0].make_lighter
    @comparer = Scale.new()
  end

  def teardown
  end
end
