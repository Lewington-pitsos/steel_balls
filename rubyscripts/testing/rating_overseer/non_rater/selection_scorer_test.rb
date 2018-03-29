require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/state_evaluator/scorer_manager/selection_manager/selection_scorer'

class SelectionScorerTest < Minitest::Test

  @@state_scores = [
    { score: 3, fully_scored: false },
    { score: 2, fully_scored: true },
    { score: 3, fully_scored: true },
    { score: 1, fully_scored: true }
  ]

  @@state_scores2 = [
    { score: 3, fully_scored: false },
    { score: 2, fully_scored: true },
    { score: 8, fully_scored: true },
    { score: 1, fully_scored: true }
  ]

  @@state_scores3 = [
    { score: 1, fully_scored: true },
    { score: 2, fully_scored: true },
    { score: 1, fully_scored: true },
    { score: 1, fully_scored: true }
  ]

  def setup
    @scorer = SelectionScorer.new()
  end

  def test_returns_correct_highest_score
    @scorer.send(:state_scores=, @@state_scores)
    score = @scorer.send(:highest_score)
    assert_equal 3, score[:score]
    refute score[:fully_scored]

    @scorer.send(:state_scores=, @@state_scores2)
    score = @scorer.send(:highest_score)
    assert_equal 8, score[:score]
    refute score[:fully_scored]

    @scorer.send(:state_scores=, @@state_scores3)
    score = @scorer.send(:highest_score)
    assert_equal 2, score[:score]
    assert score[:fully_scored]
  end

  def teardown

  end

end
