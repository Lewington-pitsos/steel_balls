require "minitest/autorun"
require_relative '../../logic/selector/omni_selector/whole_selection_generator/selection_side_generator/shover_manager.rb'

class ShoverManagerTest < Minitest::Test

  @@medium_state = {
    unknown: 4,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 0
  }


  def setup
    @counter = ShoverManager.new(@@medium_state, 4)
  end

  def teardown
  end
end
