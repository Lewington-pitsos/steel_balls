# generates and returns arrays of unmodified ball objects according to the passed in length or the number passed in to generate_balls


require_relative './ball'

class BallGenerator

  attr_reader :length

  @@default_length = 8

  def initialize(length=@@default_length)
    @length = length
  end

  def generate_balls(num=@length)
    arrangement = []
    num.times do
      arrangement << Ball.new()
    end
    arrangement
  end

  def duplicate_balls(balls)
    balls.map { |old_ball| Ball.new(old_ball.mark)  }
  end

end
