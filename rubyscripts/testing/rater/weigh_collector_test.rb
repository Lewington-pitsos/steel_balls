require "minitest/autorun"
require_relative '../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_collector'

class WeighCollectorTest < Minitest::Test

  def setup
    @collector= WeighCollector.new()
  end

  def teardown
  end
end
