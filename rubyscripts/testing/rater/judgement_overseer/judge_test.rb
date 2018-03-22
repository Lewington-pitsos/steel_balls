require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater_manager/judgement_overseer/judge_manager/judge'

class JudgeTest < Minitest::Test

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

  @@rated_basic_selection = {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}

  @@rated_other_selection = {:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>20, :state=>{:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}}, {:rating=>28, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}}]}

  @@rated_weighted_selections = [{:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}}]}}, {:rating=>28, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :states=>[{:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>28, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}, {:rating=>26, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>1}, :states=>[{:rating=>26, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>4}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}]}}, {:rating=>26, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>1}, :states=>[{:rating=>26, :state=>{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>4}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}}]}}, {:rating=>20, :selection=>{:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>20, :state=>{:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}}, {:rating=>28, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}}]}}]


  def setup
    @example_weighed_selections = [{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}, {:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>1}, :states=>[{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>4}, {:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>1}, :states=>[{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>4}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}]}, {:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}]}]

    @basic_selection = {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}, {:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}]}

    @other_selection = {:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}]}

    @judge = Judge.new()
  end

  def test_gets_correct_state_scores
    assert_equal 2, @judge.send(:rate, @@light_state)
    assert_equal 17, @judge.send(:rate, @@normal_state)
  end

  def test_scores_selections_correctly
    @judge.send(:rate_states, @basic_selection)
    assert_equal 29, @judge.send(:lowest_score)

    @judge.send(:lowest_score=, 4611686018427387903)
    @judge.send(:rate_states, @other_selection)
    assert_equal 20, @judge.send(:lowest_score)
  end

  def test_actually_modifies_rated_states
    @judge.send(:rate_states, @basic_selection)
    assert @basic_selection[:states][0][:rating]
    assert_equal @@rated_basic_selection.to_s, @basic_selection.to_s

    @judge.send(:rate_states, @other_selection)
    assert @other_selection[:states][0][:rating]
    assert_equal @@rated_other_selection.to_s, @other_selection.to_s
  end

  def test_modifies_rated_selections
    @judge.rate_selections(@example_weighed_selections)

    assert @example_weighed_selections[0][:rating]
    assert_equal @@rated_weighted_selections.length, @example_weighed_selections.length
    assert_equal @@rated_weighted_selections.to_s, @example_weighed_selections.to_s
  end

  def teardown
  end
end
