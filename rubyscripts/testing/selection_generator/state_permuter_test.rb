require "minitest/autorun"
require_relative '../../logic/selection_generator/all_selections_manager/state_permuter'

class StatePermuterTest < Minitest::Test
  
  @@unknown_state = {
    unknown: 8,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  }

  @@light_state = {
    unknown: 4,
    possibly_lighter: 8,
    possibly_heavier: 0,
    normal: 0
  }

  def setup
    @state_permuter = StatePermuter.new()
  end

  def test_generates_arrangement
    @state_permuter.send(:generate_arrangement, @@unknown_state)
    assert_equal 8, @state_permuter.send(:balls).length


    @state_permuter.send(:generate_arrangement, @@light_state)
    assert_equal 12, @state_permuter.send(:balls).length
    assert_equal 4,
      @state_permuter.send(:balls).count { |b| b.mark == :unknown }
    assert_equal 8,
      @state_permuter.send(:balls).count { |b| b.mark == :possibly_lighter }
  end

  def teardown
  end
end
