require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/interface'

class InterfaceTest < Minitest::Test

  @@state8 = {
    unknown: 8,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@state3 = {
    unknown: 3,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }


  @@state9 = {
    unknown: 9,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }


  def setup
    @interface = Interface.new(false)
  end

  def test_sets_winning_score_correctly
    @interface.send(:length=, 8)
    @interface.send(:set_winning_rating)
    assert_equal 37, $WINNING_RATING

    @interface.send(:length=, 3)
    @interface.send(:set_winning_rating)
    assert_equal 12, $WINNING_RATING

    @interface.send(:length=, 12)
    @interface.send(:set_winning_rating)
    assert_equal 57, $WINNING_RATING

    @interface.send(:length=, 16)
    @interface.send(:set_winning_rating)
    assert_equal 77, $WINNING_RATING
  end

  def test_sets_up_global_vars_correctly
    @interface.send(:length=, 8)
    @interface.send(:setup_defaults)
    assert_equal 37, $WINNING_RATING
    assert_equal 8, $DEFAULT_LENGTH

    @interface.send(:length=, 3)
    @interface.send(:setup_defaults)
    assert_equal 12, $WINNING_RATING
    assert_equal 3, $DEFAULT_LENGTH

    @interface.send(:length=, 4)
    @interface.send(:setup_defaults)
    assert_equal 17, $WINNING_RATING
    assert_equal 4, $DEFAULT_LENGTH
  end

  def test_generates_correct_starting_states
    @interface.send(:length=, 8)
    state = @interface.send(:generate_state)
    state.each do |key, value|
      assert_equal @@state8[:unknown], state[:unknown]
    end

    @interface.send(:length=, 3)
    state = @interface.send(:generate_state)
    state.each do |key, value|
      assert_equal @@state3[key], value
    end

    @interface.send(:length=, 9)
    state = @interface.send(:generate_state)
    state.each do |key, value|
      assert_equal @@state9[key], value
    end
  end

  def test_validates_correctly
    @interface.send(:length=, 8)
    assert @interface.send(:valid?)

    @interface.send(:length=, 89)
    assert @interface.send(:valid?)

    @interface.send(:length=, 3)
    assert @interface.send(:valid?)

    @interface.send(:length=, 2)
    refute @interface.send(:valid?)

    @interface.send(:length=, 1)
    refute @interface.send(:valid?)

    @interface.send(:length=, 0)
    refute @interface.send(:valid?)
  end

  def teardown
    $WINNING_RATING = 37
    $DEFAULT_LENGTH = 8
  end
end
