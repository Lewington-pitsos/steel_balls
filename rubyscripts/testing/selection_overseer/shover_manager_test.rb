require "minitest/autorun"
require 'set'
require './rubyscripts/testing/test_defaults'
require_relative '../../logic/state_evaluator/selection_overseer/omni_selector/whole_selection_generator/selection_side_generator/shover_manager.rb'

class ShoverManagerTest < Minitest::Test

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


  def setup
    @manager = ShoverManager.new(@@medium_state, 4)
  end

  def test_sets_up_counter_maxes_correctly
    assert_equal 3, @manager.counters.length
    assert_equal @@medium_state[:unknown], @manager.counters.find{ |e| e.mark == :unknown }.max
    assert_equal @@medium_state[:possibly_lighter], @manager.counters.find{ |e| e.mark == :possibly_lighter }.max
    @manager.counters.length
    assert_equal @@medium_state[:possibly_heavier], @manager.counters.find{ |e| e.mark == :possibly_heavier }.max
    refute @manager.counters.find{ |e| e.mark == :normal }


    manager2 = ShoverManager.new(@@weird_state, 1)
    assert_equal 4, manager2.counters.length
    assert_equal @@weird_state[:unknown], manager2.counters.find{ |e| e.mark == :unknown }.max
    assert_equal @@weird_state[:possibly_lighter], manager2.counters.find{ |e| e.mark == :possibly_lighter }.max
    manager2.counters.length
    assert_equal @@weird_state[:possibly_heavier], manager2.counters.find{ |e| e.mark == :possibly_heavier }.max
    assert_equal @@weird_state[:normal], manager2.counters.find{ |e| e.mark == :normal }.max
  end

  def test_links_counters_correctly
    # they link around in reverse order
    assert_same @manager.counters[1].next_counter, @manager.counters[0]

    assert_same @manager.counters[0].next_counter, @manager.counters[-1]
  end

  def test_correct_number_of_shovers
    assert_equal 4, @manager.send(:shovers).length

    manager2 = ShoverManager.new(@@medium_state, 1)
    assert_equal 1, manager2.send(:shovers).length
    manager3 = ShoverManager.new(@@medium_state, 88)
    assert_equal 88, manager3.send(:shovers).length
  end

  def test_all_shovers_start_at_lowest_possible_counter
    assert_equal 2, @manager.counters[-1].count
    assert_equal 2, @manager.counters[-2].count

    manager2 = ShoverManager.new(@@normal_state, 4)
    assert_equal 4, manager2.counters[-1].count
  end

  def test_shovers_linked_up_properly
    assert_nil @manager.send(:shovers)[0].send(:next_shover)
    assert_same @manager.send(:shovers)[0], @manager.send(:shovers)[1].send(:next_shover)
  end

  def test_state_returns_shovers
    assert_same @manager.send(:shovers), @manager.state
  end

  def test_shoving_causes_actual_shoving
    assert_equal 2, @manager.counters[-1].count
    assert_equal 2, @manager.counters[-2].count
    assert_equal 0, @manager.counters[-3].count

    @manager.shove
    assert_equal 2, @manager.counters[-1].count
    assert_equal 1, @manager.counters[-2].count
    assert_equal 1, @manager.counters[-3].count

    @manager.shove
    assert_equal 2, @manager.counters[-1].count
    assert_equal 0, @manager.counters[-2].count
    assert_equal 2, @manager.counters[-3].count
  end

  def test_never_recreates_the_same_state

    all_states = Set[]
    worked = true

    while worked
      worked = @manager.shove
      assert all_states.add?(@manager.counters.map { |c| c.count  }.join(''))
    end

    manager2 = ShoverManager.new(@@weird_state, 3)

    all_states = Set[]
    worked = true

    while worked
      worked = manager2.shove
      assert all_states.add?(manager2.counters.map { |c| c.count  }.join(''))
    end
  end

  def teardown
  end
end
