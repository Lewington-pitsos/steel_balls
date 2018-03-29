# gets passed in  a state and it's rating

# passes the ball state to the selection overseer, which saves and then returns all Rated Weighed Selections
# passes the Rated Weighed Selections to the Scorer Manager which returns a score for each passed in Selections plus a new state score

# passes the state score, the state and all the scored selections to a new state saver instance, which saves all of it.

# finally, returns the state score to the state manager

require './rubyscripts/logic/database/lookup'
require_relative './state_evaluator/scorer_manager'
require_relative './state_evaluator/rating_overseer'
require_relative './database/info_saver'

class StateEvaluator

  def initialize(state, rating, id, score=nil)
    @state = state
    @id = id
    @score = score
    @scorer = ScorerManager.new()
    @lookup = Lookup.new($DATABASE_NAME)
  end

  def state_score
    if @score
      rated_weighed_selections = recorded_rated_selections
    else
      rated_weighed_selections = new_rated_selections
    end
    scored_state_info = @scorer.scored_selections(rated_weighed_selections)
    scored_state_info[:state_score]
  end

  def new_rated_selections
    rater = RatingOverseer.new(@state, rating, @id)
    rater.rated_weighed_selections
  end

  def recorded_rated_selections
    @lookup.build_selections(@id)
  end
end
