require "minitest/autorun"
require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/lookup/tree_lookup'
require './rubyscripts/logic/state_evaluator/rating_overseer/rater_manager'


class RaterManagerTest < DatabaseTester

    @@placeholder_state = {
      unknown: 8,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    }

    @@get_all_ratings = <<~CMD
      SELECT rating FROM possible_selections ORDER BY rating DESC;
    CMD


    @@scored_and_kulled_selections = [{:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}, :id=>1}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}]}, :id=>2}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}}]}, :id=>3}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}]}, :id=>4}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}, :id=>5}]

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
    setup_database_for_testing
    add_defaults(@@placeholder_state)
    @lookup = TreeLookup.new($DATABASE_NAME)
    @manager = RaterManager.new(28, 1)
  end

  def test_correctly_weighs_and_scores
    result = @manager.weighed_and_scored(@example_selection_order)

    assert_equal @@scored_and_kulled_selections.length, result.length
    assert_equal @@scored_and_kulled_selections[-1][:rating], result[-1][:rating]
    assert_equal @@scored_and_kulled_selections.to_s, result.to_s
  end

  def test_correctly_saves_rated_weighed_selections
    @manager.weighed_and_scored(@example_selection_order)

    @lookup.build_tree
    assert_equal @@scored_and_kulled_selections.length, @lookup.tree['selections'].length

    ratings = @db.exec(@@get_all_ratings)

    sels = @@scored_and_kulled_selections.sort do |sel1, sel2|
      sel2[:rating] <=> sel1[:rating]
    end

    sels.each_with_index do |selection, index|
      assert_equal selection[:selection][:states].length, @lookup.tree['selections'][index]['states'].length

      assert_equal selection[:rating], ratings[index]['rating'].to_i
    end

  end

  def teardown
    teardown_database
  end
end
