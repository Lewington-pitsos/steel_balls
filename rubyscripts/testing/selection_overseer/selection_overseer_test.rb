require "minitest/autorun"
require "set"
require './rubyscripts/testing/test_defaults'
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

  @@medium_selection = [
    {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}]},
    {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}
  ]

  def setup
    @overseer = SelectionOverseer.new(@@medium_state)
  end

  def test_gathers_arrangements_correctly
    @overseer.send(:get_all_arranments)
    assert_equal 8, @overseer.send(:arrangements).length

    overseer = SelectionOverseer.new(@@small_state)
    overseer.send(:get_all_arranments)
    assert_equal 4, overseer.send(:arrangements).length

    overseer = SelectionOverseer.new(@@light_state)
    overseer.send(:get_all_arranments)
    assert_equal 7, overseer.send(:arrangements).length
  end

  def test_gathers_selections_correctly
    @overseer.send(:get_all_selection_orders)

    assert_equal @@medium_selection.to_s, @overseer.send(:selection_orders).to_s
  end

  def test_merges_properly
    selections = @overseer.selections_to_weigh

    selections.each do |selection|
      assert selection[:balls]
      assert_equal 8, selection[:balls].length
    end
  end

  def test_arrangeemnt_deep_cloning_on_merge
    selections = @overseer.selections_to_weigh

    all_balls = Set[]

    selections.each do |selection|
      selection[:balls].each do |ball|
        assert all_balls.add?(ball)
      end
    end
  end

  def teardown
  end
end
