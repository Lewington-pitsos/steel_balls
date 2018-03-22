# gets passed in a state and the associated state rating

# checks the database to see if the score has already been recorded
# => if so, we simply return the recorded score
# => otherwise we create a new state evaluator instance and pass it in the staet and the rating. Eventually it will return a score.

# however we got the score, we return it

require_relative './state_evaluator'

class StateManager

  def initialize(rated_state)
    @rating = rated_state[:rating]
    @state = rated_state[:state]
    @database = nil
  end

  def score

    recorded_score = score_in_database

    if recorded_score
      recorded_score
    else
      evaluator = StateEvaluator.new(@state, @rating)
      evaluator.state_score
    end
  end

  private

  def score_in_database
    # to be added
    false
  end
end
