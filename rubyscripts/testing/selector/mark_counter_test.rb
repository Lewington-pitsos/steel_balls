require "minitest/autorun"
require_relative '../../logic/selector/omni_selector/whole_selection_generator/selection_side_generator/shover_manager/mark_counter.rb'

class MarkCounterTest < Minitest::Test

  def setup
    @ball = MarkCounter.new()
  end

  def teardown
  end
end
