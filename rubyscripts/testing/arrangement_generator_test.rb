require "minitest/autorun"
require_relative '../logic/shared/arrangement_generator'

class ArrangementGeneratorTest < Minitest::Test

  def setup
    @gen = ArrangementGenerator.new()
  end

  def teardown
  end
end
