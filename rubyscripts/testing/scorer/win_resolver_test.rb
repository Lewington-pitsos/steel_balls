require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/state_evaluator/scorer_manager/win_resolver'

class WinResolverTest < Minitest::Test

  @@eaxmple_winners = [
    {selection: {}, score: {score: 0, fully_scored: true} },
    {selection: {}, score: {score: 0, fully_scored: true} }
  ]

  @@eaxmple_winners2 = [
    {selection: {}, score: {score: 3, fully_scored: true}},
    {selection: {}, score: {score: 2, fully_scored: true}},
    {selection: {}, score: {score: 3, fully_scored: false}},
    {selection: {}, score: {score: 4, fully_scored: false}},
    {selection: {}, score: {score: 3, fully_scored: true}}
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
