# so we have a bvunch of counter objects which:

# => store a mark
# => store a count (which represents the number of balls to request of this mark) and
# => store a max which represnets the number of balls that exist with the counter's mark
# store a link to the next counter

# the Shover's job is to simulate a request for a single ball. it stores:

# => a reference to a "current" counter
# => a reference to the "next", "higher order" shover
# => a reference to the "last" counter that repreents the last counter in any cycle

# to simulate a new selection request a shover will "shove", i.e. decrement the "current" counter, find the next counter that can be incremented (i.e. isn't already full), set that to the "current" one, and increment it.

# when the shover reaches the "last" counter it is considered to have completed a cycle, at which point it will prompt the "next" counter to shove once.

# it will also "skip" to whatever counter the "next" counter ended up incrementing and treat that as it's "current" counter (and increment it). This is to prevent duplication of selection orders.

# after each "shove" has completed we should have a unique selection order, and after the last shover (which should have a "next_shover" attribute of nil, ) we should have cycled through all possible selection orders



class Shover

  attr_accessor :current_counter

  def initialize(current_counter, last_counter, next_shover=nil)
    @current_counter = current_counter
    @last_counter = last_counter
    @next_shover = next_shover

    @current_counter.increment
  end

  def mark
    @current_counter.mark
  end

  def shove
    decrement
    return try_shove
  end

  private

  def try_shove
    # points the shover at the next bucket and, if that worked, tries to increment it
    # if incrmenting is impossible we recur
    # returns whether or not the increment worked (it only ever fails completely when we try to shove the nill shover)
    @successful = true

    set_current_counter
    if @successful
      try_incrementing
    end

    return @successful
  end

  def set_current_counter
    # sets the counter thuis shover is "pointitng to" for it's next attempted increment
    if @current_counter == @last_counter
      @successful = begin_new_shoving_cycle
    else
      shift_to_next_counter
    end
  end

  def try_incrementing
    # checks if the current counter is "full". If so we try another shove. Otherwise we simply increment
    if @current_counter.full
      @successful = try_shove
    else
      increment
    end
  end

  def decrement
    @current_counter.remove
  end

  def begin_new_shoving_cycle
    # shoves the next shover once, skips the first counter (has already been visited) AND moves the first counter up one, to match the start of this shove cycle. On finishing a cycle each counter must re-start from the current position of the next counter.
    if @next_shover
      shove_result = @next_shover.shove
      @current_counter = @next_shover.current_counter
      return shove_result
    else
      return false
    end
  end

  def shift_to_next_counter
    @current_counter = @current_counter.next_counter
  end

  def increment
    @current_counter.increment
  end
end
