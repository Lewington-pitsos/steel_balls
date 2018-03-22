# gets passed in  a state and it's rating

# passes the ball state to the selection overseer, which returns a pre-weigh state (consisting of all possible selections given this state, plus all possible state arrangements)
# passes the pre-weigh state plus the passed in state rating to the score overseer, which returns a score for the passed in state and an array of all the selections from the pre-weigh state with scores of their own

# passes the state score, the state and all the scored selections to a new state saver instance, which saves all of it.

# finally, returns the state score to the state manager

require_relative './state_evaluator/score_overseer'
require_relative './state_evaluator/selection_overseer'

class StateEvaluator

  def initialize(state, rating)
    @selector = SelectionOverseer.new(state)
    @scorer = ScoreOverseer.new(rating)
    @saver = nil
  end

  def state_score
    pre_weigh = @selector.selections_to_weigh
    scored_state_info = @scorer.score(pre_weigh)
    # @saver.save(scored_state_info)
    scored_state_info[:state_score]
  end
end
