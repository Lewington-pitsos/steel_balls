require "minitest/autorun"
require_relative '../logic/state_generator'
require_relative '../logic/arrangement_generator'

class StateGeneratorTest < Minitest::Test

  def setup
    @gen = StateGenerator.new()
  end

  def teardown
  end
end
