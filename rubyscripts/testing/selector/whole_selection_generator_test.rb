require "minitest/autorun"
require_relative '../../logic/selector/omni_selector/whole_selection_generator'

class WholeSelectionGeneratorTest < Minitest::Test

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


  @@small_state = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@default_start = {
    normal: 0,
    possibly_lighter: 2,
    possibly_heavier: 2,
    unknown: 0,
  }


  def setup
    @generator = WholeSelectionGenerator.new(@@medium_state)
  end

  def teardown
  end
end
