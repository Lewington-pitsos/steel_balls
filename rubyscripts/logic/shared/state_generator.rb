# takes an array of ball objets and generates and returns a "ball state" based on their marks

class StateGenerator
  def generate_state(balls)
    state = default_state
    balls.each { |ball| state[ball.mark] += 1}
    state
  end

  private

  def default_state
    # returns a new, empty state object
    {
      unknown: 0,
      possibly_lighter: 0,
      possibly_heavier: 0,
      normal: 0
    }
  end
end
