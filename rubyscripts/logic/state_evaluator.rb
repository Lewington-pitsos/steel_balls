# gets passed in  a state and it's rating

# passes the ball state to the selection overseer, which saves and then returns all Rated Weighed Selections
# passes the Rated Weighed Selections to the Scorer Manager which returns a score for each passed in Selections plus a new state score

# passes the state score, the state and all the scored selections to a new state saver instance, which saves all of it.

# finally, returns the state score to the state manager

require_relative './state_evaluator/scorer_manager'
require_relative './state_evaluator/rating_overseer'
require_relative './database/info_saver'

class StateEvaluator

  def initialize(state, rating)
    @state = state
    @rater= RatingOverseer.new(@state, rating)
    @scorer = ScorerManager.new()
    @recorder = InfoSaver.new()
    @scored_state_info = []
  end

  def state_score
    rated_weighed_selections = @rater.rated_weighed_selections
    @scored_state_info = @scorer.scored_selections(rated_weighed_selections)
    record_info
    @scored_state_info[:state_score]
  end

  private

  def record_info
    @scored_state_info[:state] = @state
    @recorder.save_everything(@scored_state_info)
  end
end
