require "minitest/autorun"
require_relative '../../logic/state_evaluator/score_overseer/rater/state_judge'

class StateJudgeTest < Minitest::Test

  @@light_state = {
    unknown: 3,
    possibly_heavier: 0,
    possibly_lighter: 1,
    normal: 0
  }

  @@normal_state = {
    unknown: 0,
    possibly_heavier: 0,
    possibly_lighter: 1,
    normal: 3
  }

  def setup
    @judge = StateJudge.new()
  end

  def test_gets_correct_scores
    assert_equal 2, @judge.send(:score, @@light_state)
    assert_equal 17, @judge.send(:score, @@normal_state)
  end

  def teardown
  end
end
