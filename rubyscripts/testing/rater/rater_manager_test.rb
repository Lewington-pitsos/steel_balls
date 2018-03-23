require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require_relative '../../logic/state_evaluator/score_overseer/rater_manager'


class RaterManagerTest < Minitest::Test

    @@scored_and_kulled_selections = [{:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}]

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

    @manager = RaterManager.new(28)
  end

  def test_correctly_weighs_and_scores
    result = @manager.weighed_and_scored(@example_selection_order)

    assert_equal @@scored_and_kulled_selections.length, result.length
    assert_equal @@scored_and_kulled_selections[-1][:rating], result[-1][:rating]
    assert_equal @@scored_and_kulled_selections.to_s, result.to_s
  end

  def teardown
  end
end
