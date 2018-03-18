require_relative '../shared/arrangement_generator'

class ArrangementExpander

  # =================== Class Stuff ======================

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

  # =================== End Class Stuff ======================

  attr_reader :weights

  def initialize
    @weights = @@weights
  end

  def expand(balls)
    # for each index in the array, we check if we can alter the ball at that index (in either direction). if so we generate a new array with that ball altered and add it to a list. Once we finish iterating we return that list

    @results = []

    set_length(balls.length)

    balls.each_index do |index|
      ball = balls[index]
      try_add_altered_arrangent(ball, index)
    end

    @results
  end

  private

  def try_add_altered_arrangent(ball, index)
    # we check if (a) the ball can be made heavier or lighter and (b) this expander is equipped to make it heavier or lighter
    # if so we generate a new array with the ball altered in the specified direction and record it
    if alter_able?(ball, :heavier) && compatible_weight?(:heavier)
      @results << altered_arrangement(index, :heavier)
    end

    if alter_able?(ball, :lighter) && compatible_weight?(:lighter)
      @results << altered_arrangement(index, :lighter)
    end
  end

  def compatible_weight?(weight)
    @weights == weight || @weights == :both
  end

  def altered_arrangement(index, weight)
    # generates a new array of balls, alters the ball at the passed in index and returns the resulting array
    arrangement = @generator.generate_balls()
    alter(arrangement, index, weight)
    arrangement
  end

  def alter(balls, index, weight)
    # checks which way we are altering the ball and alters it in that way
    if weight == :heavier
      balls[index].make_heavier
    else
      balls[index].make_lighter
    end
  end

  def set_length(length)
    @length = length
    @generator = ArrangementGenerator.new(length)
  end

  def alter_able?(ball, weight)
    @@alterable_balls[weight].include?(ball.mark)
  end
end
