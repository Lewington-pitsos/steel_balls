require "minitest/autorun"
require_relative '../../logic/selection_generator/all_selections_manager/selection_creator'

class SelectionCreatorTest < Minitest::Test

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
    @state_permuter = SelectionCreator.new()
  end

  def teardown
  end
end
