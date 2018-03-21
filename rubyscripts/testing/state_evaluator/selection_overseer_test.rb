require "minitest/autorun"
require_relative '../../logic/state_evaluator/selection_overseer'

class SelectionOverseerTest < Minitest::Test

  @@small_state = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@medium_state = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@light_state = {
    unknown: 3,
    possibly_heavier: 0,
    possibly_lighter: 1,
    normal: 0
  }


  def setup
    @overseer = SelectionOverseer.new(@@small_state)
  end

  def test_gathers_arrangements_correctly
    @overseer.send(:get_all_arranments)
    assert_equal 2, @overseer.send(:arrangements).length

    overseer = SelectionOverseer.new(@@medium_state)
    overseer.send(:get_all_arranments)
    assert_equal 4, overseer.send(:arrangements).length

    overseer = SelectionOverseer.new(@@light_state)
    overseer.send(:get_all_arranments)
    assert_equal 3, overseer.send(:arrangements).length
  end

  def teardown
  end
end
