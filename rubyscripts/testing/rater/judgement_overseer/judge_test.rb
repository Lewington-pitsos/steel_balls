require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/judgement_overseer/judge_manager/judge'

class JudgeTest < Minitest::Test

  @@example_weighed_selections = [{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}, {:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>1}, :states=>[{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>4}, {:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>1}, :states=>[{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>4}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}]}, {:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}]}]


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
    @judge = Judge.new()
  end

  def test_gets_correct_scores
    assert_equal 2, @judge.send(:rate, @@light_state)
    assert_equal 17, @judge.send(:rate, @@normal_state)
  end



  def teardown
  end
end
