require "minitest/autorun"
require './rubyscripts/testing/database_tester'
require_relative '../logic/state_evaluator/score_overseer'


class ScoreOverseerTest < DatabaseTester

  @@scored_selections = {:selections=>[{:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}, :score=>2}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}]}, :score=>2}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}}]}, :score=>2}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}]}, :score=>1}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}, :score=>1}], :state_score=>2}

  def setup
    setup_database_for_testing
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

    add_defaults(@normal_state, @fancy_state)
    @overseer = ScoreOverseer.new(28)
  end

  def test_scores_correctly
    scored_selections = @overseer.score(@example_selection_order)

    assert_equal @@scored_selections.length, scored_selections.length
    assert_equal @@scored_selections.to_s, scored_selections.to_s
  end

  def teardown
    teardown_database
  end
end
