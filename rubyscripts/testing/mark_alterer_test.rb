require "minitest/autorun"
require_relative '../logic/shared/ball'
require_relative '../logic/shared/mark_changer'
require_relative '../logic/shared/arrangement_generator'

class MarkChangerTest < Minitest::Test

  def setup
    @mark_alterer = MarkChanger.new()
    @arr_generator = ArrangementGenerator.new()
  end


  def teardown
  end
end
