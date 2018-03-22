require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater_manager/judgement_overseer/judge_manager/selection_kuller'

class SelectionKullerTest < Minitest::Test

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


  @@kulled_selections = [{:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}]


  def setup
    @kuller = SelectionKuller.new(28)
  end

  def test_kulls_correct_selections
    remaining = @kuller.kulled(@@rated_weighted_selections)

    assert_operator @@rated_weighted_selections.length, :>, remaining.length
    assert_equal 5, remaining.length
    assert_equal 29, remaining.map{ |s| s[:rating] }.min
  end

  def teardown
  end
end
