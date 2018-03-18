# takes an array of ball objects and a ball state and alters the obejcts so their marks match the state


require_relative './ball'

class MarkChanger

  @@default_state =  {
      unknown: 8,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    }

  attr_accessor :state

  def initialize
    @state = @@default_state
    @balls = []
    @index = 0
  end

  def marked_balls(balls)
    # for each kvp in the current state, we mark that number of balls with the appropriate mark. Each time we mark a ball we move to the next ball
    # as long as the number of balls in the state and the passed in array are the same we should be fine
    @balls = balls
    @index = 0


    @state.each do |mark, number|
      number.times do
        mark_ball_as(mark)
      end
    end

    @balls
  end

  private

  def mark_ball_as(mark)
    # marks the ball at the current index as the passed in mark and moves the index up one
    @balls[@index].mark = mark
    @index += 1
  end

end
