# gets passed in a (single) balance state and converts it into a single ball arrangement with each ball updated according to how they previous weigh panned out

class WeighExecutor

  @@opposites = {
    possibly_heavier: :possibly_lighter,
    possibly_lighter: :possibly_heavier
  }

  def initialize
    @balance_state = {}
  end

  def execute_weigh(balance_state)
    @balance_state = balance_state
    if balanced?
      normalize(@balance_state[:unweighed])
      re_mark_weighed_balls
    else
      normalize(@balance_state[:balanced])
    end
  end

  private

  def balanced?
    !@balance_state[:balanced].empty?
  end

  def normalize(balls)
    balls.each { |ball| ball.mark = :normal }
  end

  def re_mark_weighed_balls
    update_balls(:possibly_heavier)
    update_balls(:possibly_lighter)
  end

  def update_balls(mark)
    @balance_state[mark].each do
      update_mark(ball, mark)
    end
  end

  def update_mark(ball, mark)
    # normalizes the ball if the ball is already marked with the opposite mark, or is already normal.
    # otherwise simply re-marks the ball with the passed in mark
    if ball.mark == :normal || ball.mark == @@opposites[mark]
      ball.mark = :normal
    else
      ball.mark = mark
    end
  end

end
