require "minitest/autorun"
require_relative '../../logic/rater/state_judge'

class StateJudgeTest < Minitest::Test

  def setup
    @ball = StateJudge.new()
  end

  def teardown
  end
end
