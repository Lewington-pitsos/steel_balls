require "minitest/autorun"
require_relative '../../logic/selector/omni_selector/whole_selection_generator/selection_side_generator/shover_manager/shover.rb'

class ShoverTest < Minitest::Test

  def setup
    @ball = Shover.new()
  end

  def teardown
  end
end
