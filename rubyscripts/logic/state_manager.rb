# gets passed in a state and the associated state rating

# automatically returns 0 if the state's rating is already a winning rating, otherwise:

# checks the database to see if the score has already been recorded
# => if so, we simply return the recorded score
# => otherwise we create a new state evaluator instance and pass it in the staet and the rating. Eventually it will return a score.

# however we got the score, we return it

require_relative './state_evaluator'
require_relative './database/score_checker'

class StateManager

  def initialize(rated_state)
    @rating = rated_state[:rating]
    @state = rated_state[:state]
  end

  def score
    if @rating >= 37
      return 0
    end

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
    # creates a new score checker, gets it to return the recorded score value, and closes it immidiately to prevent connection leakage
    score_checker = ScoreChecker.new()
    score = score_checker.recorded_score(@state)
    score_checker.close()
    score
  end
end
