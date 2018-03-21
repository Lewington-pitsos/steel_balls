require "minitest/autorun"
require_relative '../../logic/selector/omni_selector/whole_selection_generator'

class WholeSelectionGeneratorTest < Minitest::Test

  @@medium_state = {
    unknown: 4,
    possibly_lighter: 2,
    possibly_heavier: 2,
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

  @@default_state_selections = [
    {
      normal: 0,
      possibly_lighter: 0,
      possibly_heavier: 2,
      unknown: 0,
    },
    {
      normal: 0,
      possibly_lighter: 1,
      possibly_heavier: 1,
      unknown: 0,
    },
    {
      normal: 0,
      possibly_lighter: 2,
      possibly_heavier: 0,
      unknown: 0,
    },
  ]

  @@medim_minus_small = {
    unknown: 2,
    possibly_lighter: 2,
    possibly_heavier: 2,
    normal: 0,
  }

  @@medim_minus_start = {
    unknown: 4,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  }

  @@mini_state = {
    normal: 0,
    possibly_lighter: 0,
    possibly_heavier: 1,
    unknown: 1,
  }

  @@tiny_state = {
    normal: 0,
    possibly_lighter: 0,
    possibly_heavier: 0,
    unknown: 1,
  }

  @@mini_minus_tiny = {
    normal: 0,
    possibly_lighter: 0,
    possibly_heavier: 1,
    unknown: 0,
  }


  def setup
    @generator = WholeSelectionGenerator.new(@@medium_state)
  end

  def test_can_clone_passed_in_state
    clone = @generator.send(:state_clone)

    assert_equal @@medium_state.to_s, clone.to_s
    refute_same @@medium_state, clone
  end

  def test_calculates_leftover_states_properly
    state = @generator.send(:leftover_state, @@small_state)
    assert_equal @@medim_minus_small.to_s, state.to_s

    state = @generator.send(:leftover_state, @@default_start)
    assert_equal @@medim_minus_start.to_s, state.to_s

    generator2 = WholeSelectionGenerator.new(@@mini_state)

    state = generator2.send(:leftover_state, @@tiny_state)
    assert_equal @@mini_minus_tiny.to_s, state.to_s
  end

  def test_generates_right_selections_correctly
    generator2 = WholeSelectionGenerator.new(@@default_start)
    generator2.send(:to_select=, 2)
    selections = generator2.send(:all_right_selections, @@default_start)
    assert_equal @@default_state_selections.length, selections.length
    assert_equal @@default_state_selections.to_s, selections.to_s

  end

  def test_never_alters_passed_in_state

  end

  def teardown
  end
end
