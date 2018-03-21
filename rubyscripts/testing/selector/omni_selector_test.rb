require "minitest/autorun"
require_relative '../../logic/selector/omni_selector'

class OmniSelectorTest < Minitest::Test

  @@medium_state = {
    unknown: 4,
    possibly_lighter: 2,
    possibly_heavier: 2,
    normal: 0
  }


  def setup
    @generator = OmniSelector.new(@@medium_state)
  end

  def teardown
  end
end
