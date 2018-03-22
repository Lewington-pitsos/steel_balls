require "minitest/autorun"
require_relative '../../logic/state_evaluator/score_overseer/scorer_manager/win_resolver'

class WinResolverTest < Minitest::Test

  @@eaxmple_winners = [
    {selection: {}, score: 0},
    {selection: {}, score: 0}
  ]

  @@eaxmple_winners2 = [
    {selection: {}, score: 3},
    {selection: {}, score: 2},
    {selection: {}, score: 3},
    {selection: {}, score: 3},
    {selection: {}, score: 4}
  ]

  def setup
    @resolver = WinResolver.new()
  end

  def test_returns_correct_state_score
    assert_equal 1, @resolver.state_score(@@eaxmple_winners)
    assert_equal 3, @resolver.state_score(@@eaxmple_winners2)
  end

  def teardown
  end
end
