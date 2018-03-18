require "minitest/autorun"
require_relative '../../logic/rater/selection_judge'

class SelectionJudgeTest < Minitest::Test

  def setup
    @judge = SelectionJudge.new()
  end

  def teardown
  end
end
