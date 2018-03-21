require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager/scale/balancer/comparer.rb'
require_relative '../../../logic/shared/arrangement_generator/ball_generator'

class ComparerTest < Minitest::Test

  @@normal_balls = BallGenerator.new().generate_balls

  def setup
    @comparer = Comparer.new()
  end

  def test_correct_total_weight
    weight = @comparer.send(:total_weight, @@normal_balls)
    assert_equal 8, weight
  end

  def teardown
  end
end
