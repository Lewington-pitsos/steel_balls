require "minitest/autorun"
require_relative '../../logic/selector/omni_selector/whole_selection_generator/selection_side_generator/shover_manager/shover.rb'
require_relative '../../logic/selector/omni_selector/whole_selection_generator/selection_side_generator/shover_manager/mark_counter.rb'


class ShoverTest < Minitest::Test

  def setup
    @counter3 = MarkCounter.new(:unknown, 4, nil)
    @counter2 = MarkCounter.new(:possbly_heavier, 4, @counter3)
    @counter1 = MarkCounter.new(:normal, 4, @counter2)
    @shover1 = Shover.new(@counter1, @counter3, nil)
  end

  def test_shifts_counters
    @shover1.send(:shift_to_next_counter)
    assert_equal @counter2, @shover1.current_counter
  end

  def test_increments_on_instantiation
    assert_equal 1, @counter1.count
  end

  def test_increments_counter
    @shover1.send(:increment)
    assert_equal 2, @counter1.count
  end

  def test_knows_current_mark
    assert_equal :normal, @shover1.mark

    @shover1.try_shove
    assert_equal :possbly_heavier, @shover1.mark
  end

  def test_doesnt_over_fill
    @counter1.increment
    @counter1.increment
    @counter1.increment

    @shover1.send(:try_incrementing)

    assert_equal 4, @counter1.count
  end

  def teardown
  end
end
