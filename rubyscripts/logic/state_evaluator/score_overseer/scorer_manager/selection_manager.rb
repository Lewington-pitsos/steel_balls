# gets passed in an array of (kulled) rated selections (plus associated rated states)
# for each selection, it passes the associated rated states to the selection scorer instance, which eventually passes back the score for the selection in question.

# each selection score is associated with its selection and placed in an array.
# this array is returned

require_relative './selection_manager/selection_scorer'

class SelectionManager

  def initialize
    @selection_scorer = SelectionScorer.new()
    @scored_selections = []
  end

  def score_all_selections(rated_selecions)
    @scored_selections = []

    rated_selecions.each do |selection|
      generate_scored_selection(selection)
    end

    @scored_selections
  end

  private

  def generate_scored_selection(selection)
    selection_object = selection[:selection]
    score = get_score(selection_object)
    selection_object.delete(:states)
    @scored_selections << { selection: selection_object, score: score }
  end

  def get_score(selection_object)
    states = selection_object[:states]
    @selection_scorer.score_selection(states)
  end

end
