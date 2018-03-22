# takes in a pre_weigh state and a minimum state rating

# creates a new rater manager by passing in the minimum state rating. It then passes the rater manager the pre_weigh state. The rater manager will pass back an array of rated selections (mapped to rated states).

# this rated selections object is then passed to the scorer manager, which eventually passes back a hash that stores a score for the current state and an array of scored selections

# this is returned

require_relative './score_overseer/rater_manager'
require_relative './score_overseer/scorer_manager'

class ScoreOverseer

  def initialize(rating)
    @rater = RaterManager.new(rating)
    @scorer = ScorerManager.new()
  end

  def score(pre_weigh_state)
    rated_selections = @rater.weighed_and_scored(pre_weigh_state)
    @scorer.scored_selections(rated_selections)
  end
end
