require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/state_evaluator/rating_overseer/omni_selector'

class OmniSelectorTest < Minitest::Test

  @@medium_state = {
    unknown: 4,
    possibly_lighter: 2,
    possibly_heavier: 2,
    normal: 0
  }

  @@smaller_state = {
    unknown: 2,
    possibly_lighter: 2,
    possibly_heavier: 2,
    normal: 0,
  }

  @@small = {
    unknown: 4,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  }

  @@mini_state = {
    normal: 0,
    possibly_lighter: 0,
    possibly_heavier: 1,
    unknown: 1,
  }

  @@big_state = {
    normal: 24,
    possibly_lighter: 0,
    possibly_heavier: 1,
    unknown: 1,
  }

  @@medium_state_selections = [{:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>0}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>0}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>0}, :right=>[{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>0}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>0}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>2, :unknown=>0}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>2}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>3}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>1}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>2}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>3}]}, {:left=>{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>1, :unknown=>0}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>2}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>3}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>2}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>2}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>3}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>2}, {:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>1}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>2}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>3}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>2, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>1}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>2}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>3}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>2, :unknown=>0}, {:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>1}, {:normal=>0, :possibly_lighter=>2, :possibly_heavier=>1, :unknown=>0}, {:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>1}, {:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>1}]}, {:left=>{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>2, :unknown=>0}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>4}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>2, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>3}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>1, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>3}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>1, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>1, :unknown=>3}, :right=>[{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>1, :unknown=>1}]}, {:left=>{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>0, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>2, :unknown=>2}]}, {:left=>{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>0, :unknown=>3}, :right=>[{:normal=>0, :possibly_lighter=>1, :possibly_heavier=>2, :unknown=>1}]}, {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>4}, :right=>[{:normal=>0, :possibly_lighter=>2, :possibly_heavier=>2, :unknown=>0}]}]


@@small_selections = [{:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}]},
{:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}]



  def setup
    @generator = OmniSelector.new()
  end

  def test_finds_proper_ball_numbers
    assert_equal [1, 2, 3, 4].to_s, @generator.send(:weighable_ball_numbers, @@medium_state).to_s
    assert_equal [1, 2, 3].to_s, @generator.send(:weighable_ball_numbers, @@smaller_state).to_s
    assert_equal [1, 2].to_s, @generator.send(:weighable_ball_numbers, @@small).to_s
    assert_equal [1].to_s, @generator.send(:weighable_ball_numbers, @@mini_state).to_s
    assert_equal [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13].to_s, @generator.send(:weighable_ball_numbers, @@big_state).to_s
  end

  def test_returns_selections_correctly
    @generator.get_all_possible_selections(@@medium_state)

    assert_equal @@medium_state_selections.length, @generator.all_selections.length
    assert_equal @@medium_state_selections.to_s, @generator.all_selections.to_s

    @generator.get_all_possible_selections(@@small)

    assert_equal @@small_selections.length, @generator.all_selections.length
    assert_equal @@small_selections.to_s, @generator.all_selections.to_s
  end

  def teardown
  end
end
