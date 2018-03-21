# this guy contains all the shovers and counters and returns the "shover state" i.e. where each shover is currently "pointing". This is then used by SelectionGenerator to craete a unique selection order

require_relative './shover_manager/mark_counter'
require_relative './shover_manager/shover'

class ShoverManager

  attr_accessor :counters

  def initialize(ball_state, balls_requested)
    setup_counters(ball_state)
    setup_shovers(balls_requested)
    @first_shover = @shovers[-1]
  end

  def shove
    # causes a shove and returns the result
    return @first_shover.shove
  end

  def state
    @shovers
  end

  private

  attr_accessor :shovers

  def setup_counters(state)
    # resets the counters array with counter objects whose marks and numbers correspond to the passed in ball state. If there are no balls in a given state category we omit to create a counter for it.
    # Each counter links to the previous counter (and first links to last)

    @counters = []
    previous_counter = nil

    state.each do |mark, number|
      if number > 0
        new_counter = MarkCounter.new(mark, number, previous_counter)
        @counters << new_counter
        previous_counter = new_counter
      end
    end

    @counters[0].reset_next_counter(previous_counter)
  end

  def setup_shovers(shover_number)
    # Creates a shover instance for each ball requested. Each shover links to the previous one execpt the first which links to nil. All shovers start pointing at the first counter.

    @shovers = []
    previous_shover = nil
    @first_counter = @counters[-1]
    last_counter = @counters[0]

    shover_number.times do
      correct_first_counter
      shover = Shover.new(@first_counter, last_counter, previous_shover)
      @shovers << shover
      previous_shover = shover
    end
  end

  def correct_first_counter
    if @first_counter.full
      @first_counter = @first_counter.next_counter
    end
  end
end
