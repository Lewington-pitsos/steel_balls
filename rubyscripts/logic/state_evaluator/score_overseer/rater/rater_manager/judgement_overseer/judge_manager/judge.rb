# gets passed in a weight_outcome object, which should map a whole bunch of selectors to the ball states which result from making weighs according to that selector.

# passes out nothing. It modifies the weigh_outcome by scoring every state.

class Judge

  @@scores = {
    unknown: 0,
    possibly_lighter: 2,
    possibly_heavier: 2,
    normal: 5
  }

  def initialize
    @lowest_score = 4611686018427387903
  end

  def rate_selections(weighed_selections)
    weighed_selections.each do |selection|
      @lowest_score = 4611686018427387903
      rate_states(selection)
      selection = rated_selection(selection)
    end
  end

  private

  def rate_states(selection)
    # rates each state and replaces it with a rated state object which stores both the score and the state
    selection[:states].each do |state|
      rating = rate(state)
      if rating < @lowest_score
        @lowest_score = rating
      end
      state = rated_state(state, rating)
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
      rating: @lowest_score,
      selection: selection
    }
  end

end
