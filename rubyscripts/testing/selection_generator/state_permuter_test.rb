require "minitest/autorun"
require_relative '../../logic/selection_generator/all_selections_manager/state_permuter'

class StatePermuterTest < Minitest::Test

  @@default_state = {
    unknown: 0,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  }

  @@unknown_state = {
    unknown: 8,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  }

  @@light_state = {
    unknown: 0,
    possibly_lighter: 8,
    possibly_heavier: 0,
    normal: 0
  }

  def setup
    @state_gen = StateGenerator.new()
    @arr_gen = BallGenerator.new()
  end

  def teardown
  end
end
