require "minitest/autorun"
require_relative '../../logic/selector/omni_selector/whole_selection_generator/selection_side_generator.rb'

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


  @@weird_state = {
    unknown: 1,
    possibly_heavier: 9,
    possibly_lighter: 2,
    normal: 100
  }

  @@default_start = {
    normal: 0,
    possibly_lighter: 2,
    possibly_heavier: 2,
    unknown: 0,
  }


  def setup
    @generator = SelectionSideGenerator.new(@@medium_state, 4)
  end

  def test_default_selection_recorded
    assert_equal 1, @generator.all_selections.length
    assert_equal @@default_start.to_s, @generator.all_selections[0].to_s
  end

  def teardown
  end
end
