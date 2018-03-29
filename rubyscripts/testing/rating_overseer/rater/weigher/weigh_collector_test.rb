require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require_relative '../../../logic/state_evaluator/score_overseer/rater_manager/weigher/weigh_collector'


class WeighCollectorTest < Minitest::Test

  @@collected_results = [{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}, {:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>1}, :states=>[{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>4}, {:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}]}, {:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>1}, :states=>[{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>4}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}, {:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}]}, {:left=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :right=>{:unknown=>2, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>0}, :states=>[{:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>4}]}]


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
      right: [
          {
            unknown: 2,
            possibly_heavier: 0,
            possibly_lighter: 0,
            normal: 0
          }
        ],
      balls: @normal_arrangements
    }

    @fancy_state = {
      unknown: 2,
      possibly_heavier: 2,
      possibly_lighter: 2,
      normal: 2
    }

    @fancy_arrangements = StateExpander.new.expand(@fancy_state)

    @fancy_selection = {
      left: {
        unknown: 1,
        possibly_heavier: 0,
        possibly_lighter: 0,
        normal: 1
      },
      right: [
        {
          unknown: 0,
          possibly_heavier: 2,
          possibly_lighter: 0,
          normal: 0
        },
        {
          unknown: 0,
          possibly_heavier: 1,
          possibly_lighter: 1,
          normal: 0
        },
        {
          unknown: 0,
          possibly_heavier: 0,
          possibly_lighter: 2,
          normal: 0
        },
        {
          unknown: 1,
          possibly_heavier: 0,
          possibly_lighter: 0,
          normal: 1
        },
        {
          unknown: 1,
          possibly_heavier: 1,
          possibly_lighter: 0,
          normal: 0
        },
        {
          unknown: 1,
          possibly_heavier: 0,
          possibly_lighter: 1,
          normal: 0
        },
        {
          unknown: 0,
          possibly_heavier: 1,
          possibly_lighter: 0,
          normal: 1
        },
        {
          unknown: 0,
          possibly_heavier: 0,
          possibly_lighter: 1,
          normal: 1
        }
      ],
      balls: @fancy_arrangements
    }

    @example_selection_order = [
      @fancy_selection,
      @normal_selection
    ]

    @collector= WeighCollector.new()
  end

  def test_correct_weigh_results_collected
    @collector.collect_all_weighs(@example_selection_order)
    assert_equal @@collected_results.to_s, @collector.weighed_selections.to_s
  end

  def teardown
  end
end
