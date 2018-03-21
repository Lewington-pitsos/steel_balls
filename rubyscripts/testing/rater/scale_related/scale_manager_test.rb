require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager'
require_relative '../../../logic/shared/arrangement_generator/ball_generator'

class ScaleManagerTest < Minitest::Test

  @@normal_balls = BallGenerator.new.generate_balls

  @@weird_balls = BallGenerator
    .new
    .generate_balls
    .each { |ball| ball.make_heavier  }

  def setup
    @lighter_balls = BallGenerator.new.generate_balls
    @lighter_balls[0].make_lighter
    @comparer = ScaleManager.new()
  end

  def teardown
  end
end
