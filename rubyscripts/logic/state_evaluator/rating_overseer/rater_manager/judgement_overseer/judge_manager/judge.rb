# gets passed in a weight_outcome object, which should map a whole bunch of selectors to the ball states which result from making weighs according to that selector.

# passes out nothing. It modifies the weigh_outcome by scoring every state based on its balls and every selection based on its states.

class Judge

  @@scores = {
    unknown: $UNKNOWN_SCORE,
    possibly_lighter: $HALF_SCORE,
    possibly_heavier: $HALF_SCORE,
    normal: $NORMAL_SCORE
  }

  def initialize
    @lowest_rating = 4611686018427387903
  end

  def rate_selections(weighed_selections)
    weighed_selections.each_with_index do |selection, index|
      @lowest_rating = 4611686018427387903
      rate_states(selection)
      weighed_selections[index] = rated_selection(selection)
    end
  end

  private

  attr_accessor :lowest_score

  def rate_states(selection)
    # rates each state and replaces it with a rated state object which stores both the score and the state
    selection[:states].each_with_index do |state, index|
      rating = rate(state)
      if rating < @lowest_rating
        @lowest_rating = rating
      end
      selection[:states][index] = rated_state(state, rating)
    end
  end

  def rated_state(state, rating)
    {
      rating: rating,
      state: state
    }
  end

  def rate(state)
    state.inject(0) do |total, counter|
      total += counter[1] * @@scores[counter[0]]
    end
  end

  def rated_selection(selection)
    {
      rating: @lowest_rating,
      selection: selection
    }
  end

end
