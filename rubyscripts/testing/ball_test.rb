require "minitest/autorun"
require_relative '../logic/shared/arrangement_generator/ball'

class BallTest < Minitest::Test

  def setup
    @ball = Ball.new()
  end

  def test_default_mark_is_unknown
    assert_equal :unknown, @ball.mark
  end

  def test_mark_can_change
    @ball.mark = :normal
    assert_equal :normal, @ball.mark
  end

  def test_default_weight
    assert_equal 1 , @ball.weight
  end

  def test_cannot_chnage_weight_directly
    assert_raises 'Error' do
      @ball.weight = 5
    end
  end

  def test_can_change_weight_indirectly
    assert_equal 1 , @ball.weight
    @ball.make_heavier
    assert_equal 2, @ball.weight
    @ball.make_lighter
    assert_equal 0, @ball.weight
  end


  def teardown
  end
end
