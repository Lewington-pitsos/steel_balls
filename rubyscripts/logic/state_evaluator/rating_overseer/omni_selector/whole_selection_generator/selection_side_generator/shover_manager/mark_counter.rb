# This represents the number of balls to select from a given mark (as part of a selection order)

# we give it a mark and the next counter in the list of counters. it has the ability to "shove" one of the balls (that the @count integer represents) to the next counter

class MarkCounter

  attr_accessor :count, :mark, :next_counter, :max

  def initialize(mark, max, next_counter)
    @max = max
    @mark = mark
    @count = 0
    @next_counter = next_counter
  end

  def full
    @count == @max
  end

  def reset_next_counter(counter)
    @next_counter = counter
  end

  def increment
    @count += 1
  end

  def remove
    @count -= 1
  end
end
