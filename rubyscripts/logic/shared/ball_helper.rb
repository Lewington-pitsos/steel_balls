module BallHelper

  def duplicate_balls(balls)
    balls.map { |old_ball| Ball.new(old_ball.mark)  }
  end

end
