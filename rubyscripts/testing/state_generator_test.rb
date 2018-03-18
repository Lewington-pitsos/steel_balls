require "minitest/autorun"
require_relative '../logic/state_generator'
require_relative '../logic/arrangement_generator'

class StateGeneratorTest < Minitest::Test

  @@default_state = {
    unknown: 0,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  }

  @@unknown_state = {
    unknown: 8,
    possibly_lighter: 0,
    possibly_heavier: 0,
    normal: 0
  }

  @@light_state = {
    unknown: 0,
    possibly_lighter: 8,
    possibly_heavier: 0,
    normal: 0
  }

  def setup
    @state_gen = StateGenerator.new()
    @arr_gen = ArrangementGenerator.new()
  end

  def test_default_state
    assert_equal @@default_state.to_s, @state_gen.send(:default_state).to_s
  end

  def test_generates_correct_state
    state = @state_gen.generate_state(@arr_gen.generate_balls())
    assert_equal(state.to_s, @@unknown_state.to_s)

    balls = @arr_gen.generate_balls()
    balls.each { |ball| ball.make_lighter }

    state = @state_gen.generate_state(balls)
    assert_equal(state.to_s, @@light_state.to_s)
  end

  def teardown
  end
end
