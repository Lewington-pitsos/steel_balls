# gets passed in a selection object whose states have already been scored, generates a score for that selection, and adds it to the seletion object

class SelectionJudge

  def initialize

  end

  def score_selection(selection)
    # ietrates throough all associated states and records the lowerst score among them. Sets the score of the current selection to that.
    score = selection.map do |state|
      state.score
    end.min
    selection[:score] = score
  end

end
