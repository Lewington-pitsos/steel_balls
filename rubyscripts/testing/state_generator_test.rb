require "minitest/autorun"
require_relative '../logic/shared/state_generator'
require_relative '../logic/shared/arrangement_generator'

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
    assert_raises 'ERROR' do
      @state_gen.default_state
    end
    assert_equal @@default_state.to_s, @state_gen.send(:default_state).to_s
  end

  def test_generates_correct_state
    state = @state_gen.generate_state(@arr_gen.generate_balls())
    assert_equal @@unknown_state.to_s, state.to_s

    balls = @arr_gen.generate_balls()
    balls.each { |ball| ball.mark = :possibly_lighter }

    state = @state_gen.generate_state(balls)
    assert_equal @@light_state.to_s, state.to_s
  end

  def teardown
  end
end
