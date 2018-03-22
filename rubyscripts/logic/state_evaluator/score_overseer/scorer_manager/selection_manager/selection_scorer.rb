# takes in an array of(rated) states
# [ { rating: int, state: ball_state }, ... ]
# returns the score for the associated selection

# for each state, it creates a new state manager, passing in a single state (and it's rating). the state manager will pass back the SCORE for that state

# all the states are listed out in an array, and the selection score becomes the same as the highest state score in that array (i.e. the worst possible outcome from weighing with the selection in question)

# finally we return this score

require_relative '../../../../state_manager'

class SelectionScorer

  def initialize
    @state_scores = []
  end

  def score_selection(states)
    @state_scores = []
    states.each do |rated_state|
      manager = StateManager.new(rated_state)
      @state_scores << manager.score
    end

    highest_score
  end

  private

  def highest_score
    @state_scores.max
  end

end
