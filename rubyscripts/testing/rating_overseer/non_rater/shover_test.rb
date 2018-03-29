require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/state_evaluator/rating_overseer/omni_selector/whole_selection_generator/selection_side_generator/shover_manager/shover.rb'



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

    @shover1.send(:try_shove)
    assert_equal :possbly_heavier, @shover1.mark
  end

  def test_doesnt_over_fill
    @counter1.increment
    @counter1.increment
    @counter1.increment

    @shover1.send(:try_incrementing)

    assert_equal 4, @counter1.count
  end

  def test_decriments_current_bucket_on_shove
    @shover1.shove
    assert_equal 0, @counter1.count
  end

  def test_increments_next_counter_if_current_one_full
    @counter1.increment
    @counter1.increment
    @counter1.increment

    @shover1.shove
    assert_equal 1, @counter2.count
  end

  def test_keeps_skipping_till_a_non_full_counter_is_found
    @counter1.increment
    @counter1.increment
    @counter1.increment

    @counter2.increment
    @counter2.increment
    @counter2.increment
    @counter2.increment

    @shover1.shove
    assert_equal 1, @counter3.count
  end

  def test_shoves_next_shover_on_cycle_completion_repositions_itself
    @shover2 = Shover.new(@counter1, @counter3, @shover1)
    assert_equal :normal, @shover1.mark
    assert_equal :normal, @shover2.mark

    @shover2.shove
    assert_equal :possbly_heavier, @shover2.mark

    @shover2.shove
    assert_equal :unknown, @shover2.mark

    @shover2.shove
    assert_equal :possbly_heavier, @shover1.mark
    assert_equal :possbly_heavier, @shover2.mark
  end

  def test_shoves_truth_values_are_correct
    assert @shover1.shove

    @counter3.increment
    @counter3.increment
    @counter3.increment
    @counter3.increment

    refute @shover1.shove
  end

  def test_fullness_matters_when_restarting_cycles
    @counter2.increment
    @counter2.increment
    @counter2.increment

    @shover2 = Shover.new(@counter1, @counter3, @shover1)
    assert_equal :normal, @shover1.mark
    assert_equal :normal, @shover2.mark

    @shover2.shove
    assert_equal :possbly_heavier, @shover2.mark

    @shover2.shove
    assert_equal :unknown, @shover2.mark

    @shover2.shove
    assert_equal :possbly_heavier, @shover1.mark
    assert_equal :unknown, @shover2.mark
  end

  def teardown
  end
end
