require "minitest/autorun"
require_relative '../../logic/state_evaluator/score_overseer/rater/rater_manager'

class RaterManagerTest < Minitest::Test

  def setup
    @manager = RaterManager.new()
  end

  def teardown
  end
end
