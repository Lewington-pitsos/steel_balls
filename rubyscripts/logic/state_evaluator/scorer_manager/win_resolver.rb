# gets passed in an array of scored_selections, e.g. :
# {selection: {left: ball_state, right: ball_state }, score: int}

# returns the score for the state (the lowest selection score + 1)

class WinResolver

  def state_score(scored_selections)
    scored_selections.map { |selection| selection[:score][:score] }.min + 1
  end

end
