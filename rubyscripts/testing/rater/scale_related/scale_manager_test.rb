require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager'
require_relative '../../../logic/state_evaluator/selection_overseer/all_arrangements/state_expander'

class ScaleManagerTest < Minitest::Test

  def setup
    @normal_state = {
      unknown: 8,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    }

    @normal_arrangements = StateExpander.new.expand(@normal_state)

    @normal_selection = {
      left: {
        unknown: 2,
        possibly_heavier: 0,
        possibly_lighter: 0,
        normal: 0
      },
      right: {
        unknown: 2,
        possibly_heavier: 0,
        possibly_lighter: 0,
        normal: 0
      },
      balls: @normal_arrangements
    }

    @normal_simple_selections = [{:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>[:unknown, 2]}, {:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>[:possibly_heavier, 0]}, {:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>[:possibly_lighter, 0]}, {:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>[:normal, 0]}]


    @manager = ScaleManager.new()
  end

  def test_generates_selections_correctly
    @manager.send(:parse_selection_order, @normal_selection)
    @manager.send(:generate_all_selections)
    assert_equal 4, @manager.send(:selections).length

    assert_equal @normal_simple_selections.to_s, @manager.send(:selections).to_s

  end

  def teardown
  end
end
