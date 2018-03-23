require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require_relative '../../logic/state_evaluator/selection_overseer/omni_selector/whole_selection_generator/selection_side_generator.rb'

class SelectionSideGeneratorTest < Minitest::Test

  @@medium_state = {
    unknown: 4,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 0
  }

  @@normal_state = {
    unknown: 4,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 8
  }


  @@small_state = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@default_start = {
    normal: 0,
    possibly_lighter: 2,
    possibly_heavier: 2,
    unknown: 0,
  }

  @@second_state = {
    normal: 0,
    possibly_lighter: 2,
    possibly_heavier: 1,
    unknown: 1,
  }

  @@third_state = {
    normal: 0,
    possibly_lighter: 2,
    possibly_heavier: 0,
    unknown: 2,
  }


  def setup
    @generator = SelectionSideGenerator.new(@@medium_state, 4)
    @generator.next_selection
  end

  def test_default_selection_recorded
    assert_equal 1, @generator.all_selections.length
    assert_equal @@default_start.to_s, @generator.all_selections[0].to_s
  end

  def test_new_selections_generated_and_returned
    state = @generator.next_selection
    assert_equal 2, @generator.all_selections.length
    assert_equal state, @@second_state
    state = @generator.next_selection
    assert_equal 3, @generator.all_selections.length
    assert_equal state, @@third_state
  end

  def test_returns_false_if_a_shove_fails
    generator = SelectionSideGenerator.new(@@small_state, 2)

    generator.next_selection

    refute generator.next_selection
  end

  def teardown
  end
end
