class ArrangementExpander

  @@alterable_balls = {
    lighter: [:unknown, :possibly_lighter],
    heavier: [:unknown, :possibly_heavier],
    both: [:unknown, :possibly_lighter, :possibly_heavier]
  }

  @@weights = :heavier

  def self.weights
    @@weights
  end

  def self.weights=(value)
    @@weights = value
  end

  attr_reader :weights

  def initialize
    @weights = @@weights
  end

  def expand(balls)
    # for each index in the array, checks if the ball at that index can be altered
    # => if not we just move to the next balls
    # => otherwise, we generate a new ball array of the same length, altering the ball at the current index and store this in a results array
    # finally we return the results array

    results = []

    @length = balls.length

    for index in @length
      if alter_able?(balls[index])
        results << altered_arrangement(index)
      end
    end

    results
  end

  private

  def alter_able?(ball)
    @@alterable_balls[@weights].include?(ball.mark)
  end
end
