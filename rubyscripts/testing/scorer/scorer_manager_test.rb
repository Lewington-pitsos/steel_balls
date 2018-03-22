require "minitest/autorun"
require_relative '../../logic/state_evaluator/score_overseer/scorer_manager'

class ScorerManagerTest < Minitest::Test

  def setup
    @winning_rated_selections = [{:rating=>37, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}]}}, {:rating=>37, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}]

    @manager = ScorerManager.new()
  end

  def test_returns_correct_state_score_if_winners
    selections = @manager.scored_selections(@winning_rated_selections)
    assert_equal 1, selections[:state_score]
    assert selections[:selections].any?
    assert selections[:selections][0][:selection][:left]
  end

  def test_score_all_always_returns_scored_selections
    selections = @manager.send(:score_all, @winning_rated_selections)
    selections.each do |selection|
      assert selection[:score]
      assert selection[:selection]
      assert_instance_of Integer, selection[:score]
    end
  end

  def teardown
  end
end
