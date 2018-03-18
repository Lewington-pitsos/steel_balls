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
    # for each index in the array, checks if the ball at that index can be altered
    # => if not we just move to the next balls
    # => otherwise, we generate a new ball array of the same length, altering the ball at the current index and store this in a results array
    # finally we return the results array

    @results = []

    set_length(balls.length)

    balls.each_index do |index|
      puts balls[index].mark
      if alter_able?(balls[index])
        add_altered_arrangement(index)
      end
    end

    @results
  end

  private

  def add_altered_arrangement(index)
    if @weights == :heavier || @weights == :both
      @results << altered_arrangement(index, :heavier)
    end

    if @weights == :lighter || @weights == :both
      @results << altered_arrangement(index, :lighter)
    end
  end

  def altered_arrangement(index, weight)
    # generates a new array of balls, alters the ball at the passed in index and returns the resulting array
    arrangement = @generator.generate_balls()
    alter(arrangement, index, weight)
    arrangement
  end

  def alter(balls, index, weight)
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

  def alter_able?(ball)
    @@alterable_balls[@weights].include?(ball.mark)
  end
end
