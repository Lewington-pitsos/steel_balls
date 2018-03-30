# takes in an array of(rated) states
# [ { rating: int, state: ball_state }, ... ]
# returns the score for the associated selection

# for each state, it creates a new state manager, passing in a single state (and it's rating). the state manager will pass back the SCORE for that state

# all the states are listed out in an array, and the selection score becomes the same as the highest state score in that array (i.e. the worst possible outcome from weighing with the selection in question)

# finally we return this score

require './rubyscripts/logic/state_manager'

class SelectionScorer

  def initialize
    @state_scores = []
  end

  def score_selection(states)
    @state_scores = []
    states.each do |rated_state|
      $LOGGER.debug("Scoring new state: #{rated_state}")
      manager = StateManager.new(rated_state)
      @state_scores << manager.score
      $LOGGER.debug("\nState Score successfully calculated")
    end

    highest_score
  end

  private

  attr_writer :state_scores

  def highest_score
    # returns a hash containing the highes score from among the score hashes, and whether or not the current selection ahs been fully scored or not (i.e. whether all of it's states have been calculated already or not) based on whether ANY of the states have yet to be fully calculated.
    max = @state_scores[0][:score]
    fully_scored = true
    @state_scores.each do |score|
      if score[:score] > max
        max = score[:score]
      end
      if !score[:fully_scored]
        fully_scored = false
      end
    end

    { score: max, fully_scored: fully_scored }
  end

end
