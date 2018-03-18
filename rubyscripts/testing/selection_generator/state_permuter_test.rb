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

  @@small_state = {
    unknown: 2,
    possibly_lighter: 1,
    possibly_heavier: 1,
    normal: 0
  }

  @@array_permutations = '[[1, 2], [1, 3], [1, 4], [2, 1], [2, 3], [2, 4], [3, 1], [3, 2], [3, 4], [4, 1], [4, 2], [4, 3], [1, 2, 3, 4], [1, 2, 4, 3], [1, 3, 2, 4], [1, 3, 4, 2], [1, 4, 2, 3], [1, 4, 3, 2], [2, 1, 3, 4], [2, 1, 4, 3], [2, 3, 1, 4], [2, 3, 4, 1], [2, 4, 1, 3], [2, 4, 3, 1], [3, 1, 2, 4], [3, 1, 4, 2], [3, 2, 1, 4], [3, 2, 4, 1], [3, 4, 1, 2], [3, 4, 2, 1], [4, 1, 2, 3], [4, 1, 3, 2], [4, 2, 1, 3], [4, 2, 3, 1], [4, 3, 1, 2], [4, 3, 2, 1]]'


  @@split_permutations = "[[[1], [2]], [[1], [3]], [[1], [4]], [[2], [1]], [[2], [3]], [[2], [4]], [[3], [1]], [[3], [2]], [[3], [4]], [[4], [1]], [[4], [2]], [[4], [3]], [[1, 2], [3, 4]], [[1, 2], [4, 3]], [[1, 3], [2, 4]], [[1, 3], [4, 2]], [[1, 4], [2, 3]], [[1, 4], [3, 2]], [[2, 1], [3, 4]], [[2, 1], [4, 3]], [[2, 3], [1, 4]], [[2, 3], [4, 1]], [[2, 4], [1, 3]], [[2, 4], [3, 1]], [[3, 1], [2, 4]], [[3, 1], [4, 2]], [[3, 2], [1, 4]], [[3, 2], [4, 1]], [[3, 4], [1, 2]], [[3, 4], [2, 1]], [[4, 1], [2, 3]], [[4, 1], [3, 2]], [[4, 2], [1, 3]], [[4, 2], [3, 1]], [[4, 3], [1, 2]], [[4, 3], [2, 1]]]"

  def setup
    @state_permuter = StatePermuter.new()
  end

  def test_generates_arrangement
    balls = @state_permuter.send(:generate_arrangement, @@unknown_state)
    assert_equal 8, balls.length


    balls = @state_permuter.send(:generate_arrangement, @@light_state)
    assert_equal 12, balls.length
    assert_equal 4,
      balls.count { |b| b.mark == :unknown }
    assert_equal 8,
      balls.count { |b| b.mark == :possibly_lighter }
  end

  def test_permutes_even_lengthed_arrays_properly
    array = [1, 2, 3, 4]
    @state_permuter.send(:generate_all_permutations, array)
    assert_equal @@array_permutations, @state_permuter.send(:perms).to_s
  end

  def test_splits_permutations_in_half
    array = [1, 2, 3, 4]
    @state_permuter.send(:generate_all_permutations, array)
    @state_permuter.send(:split_permutations)
    assert_equal @@split_permutations, @state_permuter.send(:perms).to_s
  end

  def test_returns_list_of_split_permutations
    perms = @state_permuter.send(:permute_state, @@small_state)
    assert_equal 36, perms.length
  end

  def teardown
  end
end
