require "minitest/autorun"
require_relative '../../logic/state_evaluator/score_overseer/rater/selection_judge'

class SelectionJudgeTest < Minitest::Test

  def setup
    @judge = SelectionJudge.new()
  end

  def teardown
  end
end
