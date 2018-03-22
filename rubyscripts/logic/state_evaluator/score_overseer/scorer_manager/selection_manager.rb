# gets passed in an array of (kulled) rated selections (plus associated rated states)
# for each selection, it passes the associated rated states to the selection scorer instance, which eventually passes back the score for the selection in question.

# each selection score is associated with its selection and placed in an array.
# this array is returned

require_relative './selection_manager/selection_scorer'
require 'pry'
class SelectionManager

  def initialize
    @selection_scorer = SelectionScorer.new()
    @scored_selections = []
  end

  def score_all_selections(rated_selecions)
    # generates a scored selection object for each rated selection passed in
    #binding.pry
    @scored_selections = []

    rated_selecions.each do |selection|
      generate_scored_selection(selection)
    end

    @scored_selections
  end

  private

  attr_reader :scored_selections

  def generate_scored_selection(rated_selection)
    # seperates the selection from it's rating, generates a score for it, deletes it's states and adds it to the array of scored selections
    selection = rated_selection[:selection]
    score = get_score(selection)
    selection.delete(:states)
    @scored_selections << { selection: selection, score: score }
  end

  def get_score(selection)
    states = selection[:states]
    @selection_scorer.score_selection(states)
  end

end
