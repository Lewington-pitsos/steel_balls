require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/state_evaluator/rating_overseer/omni_selector/whole_selection_generator/selection_side_generator/shover_manager/mark_counter.rb'

class MarkCounterTest < Minitest::Test

  def setup
    @counter = MarkCounter.new(:unknown, 4, nil)
  end

  def test_starts_at_zero
    assert_equal 0, @counter.count
  end

  def test_increments_properly
    @counter.increment
    assert_equal 1, @counter.count
  end

  def test_knows_when_full
    @counter.increment
    @counter.increment
    @counter.increment
    @counter.increment
    assert @counter.full
  end

  def test_resets_next_counter
    refute @counter.next_counter
    @counter.next_counter = MarkCounter.new(:unknown, 4, nil)
    assert @counter.next_counter
  end

  def teardown
  end
end
