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

  def judge_states(weighed_selections)
    weighed_selections.each do |selection|
      score_states(selection)
    end
  end

  private

  def score_states(selection)
    selection[:states].each do |state|
      score = score(state)
    end
  end

  def score(state)
    state.inject(0) do |total, counter|
      total += counter[1] * @@scores[counter[0]]
    end
  end

end
