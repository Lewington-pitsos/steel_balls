# takes in a state and returns an array of balls that match the state

require_relative './arrangement_generator/ball_generator'
require_relative './arrangement_generator/mark_changer'


class ArrangementGenerator

  @@default_length = 8

  def initialize(length=false)
    @length = @@default_length
    @ball_generator = BallGenerator.new(length)
    @changer = MarkChanger.new()
  end

  def marked_balls(state)
    # generates a new array of blank balls, alters them to match the passed in state and returns them
    balls = @ball_generator.generate_balls()
    @changer.marked_balls(balls, state)
  end

  private

  def get_length(state)
    state.inject(0) {|sum, counter|  sum + counter[1] }
  end

end
