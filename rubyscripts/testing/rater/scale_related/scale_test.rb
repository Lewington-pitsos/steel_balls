require "minitest/autorun"
require_relative '../../../logic/state_evaluator/score_overseer/rater/rater_manager/weigher/weigh_manager/weigh_collector/scale_manager/scale'
require_relative '../../../logic/state_evaluator/selection_overseer/all_arrangements/state_expander'

class ScaleTest < Minitest::Test

  @@normal_state = {
    unknown: 8,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@normal_selection = {
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
    }
  }

  @@normal_arrangements = StateExpander.new.expand(@@normal_state)

  @@normal_balance = [{:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}, {:unknown=>4, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>4}]


  @@fancy_state = {
    unknown: 2,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 2
  }

  @@fancy_selection = {
    left: {
      unknown: 1,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 1
    },
    right: {
      unknown: 0,
      possibly_heavier: 2,
      possibly_lighter: 0,
      normal: 0
    }
  }

  @@fancy_arrangements = StateExpander.new.expand(@@fancy_state)

  @@fancy_balance = [{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}, {:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}, {:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}, {:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}]


  def setup
    @scale = Scale.new()
  end

  def test_weigh_outcomes_as_expectded
    @scale.arrangements = @@normal_arrangements
    @scale.weigh(@@normal_selection)
    assert_equal @@normal_balance.to_s, @scale.selection_order[:states].to_s

    @scale.arrangements = @@fancy_arrangements
    @scale.weigh(@@fancy_selection)
    assert_equal @@fancy_balance.to_s, @scale.selection_order[:states].to_s
  end

  def teardown
  end
end
