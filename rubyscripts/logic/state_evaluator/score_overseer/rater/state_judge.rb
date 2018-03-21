# gets passed in a weight_outcome object, which should map a whole bunch of selectors to the ball states which result from making weighs according to that selector.

# passes out nothing. It modifies the weigh_outcome by scoring every state.

class StateJudge

  @@scores = {
    unknown: 0,
    possibly_lighter: 2,
    possibly_heavier: 2,
    normal: 5
  }

  def initialize

  end

  def judge_states(weigh_outcome)
    weigh_outcome.each do |selection|
      score_states(selection)
    end
  end

  private

  def score_states(selection)
    selection.each do |state|
      state[:score] = score(state)
    end
  end

  def score(state)
    state.inject(0) do |total, counter|
      total += counter[1] * @@scores[counter[0]]
    end
  end

end
