# gets passed in a state and the associated state rating

# automatically returns 0 if the state's rating is already a winning rating, otherwise:

# checks the database to see if the score has already been recorded
# => if so, we simply return the recorded score
# => otherwise we create a new state evaluator instance and pass it in the staet and the rating. Eventually it will return a score.

# however we got the score, we return it

require './rubyscripts/logic/database/info_saver/state_recorder'
require './rubyscripts/logic/database/score_recorder'
require_relative './state_evaluator'
require_relative './database/state_checker'


class StateManager

  def initialize(rated_state)
    @rating = rated_state[:rating]
    @state = rated_state[:state]
    @state_info = []
  end

  def score
    if @rating >= ($WINNING_RATING || 37)
      return fully_calculated_score(0)
    end

    get_recorded_state_info()

    if !@state_info
      score_for_new_state()
    elsif state_is_fully_calculated?()
      fully_calculated_score(state_score())
    else
      updated_score()
    end
  end

  private

  attr_reader :state_info, :new_state_id

  def fully_calculated_score(score)
    {score: score, fully_scored: true}
  end

  def updated_score
    # passes the recorded state's state, rating, id and score to StateEvaluator, which will eventually return a score
    evaluator = StateEvaluator.new(@state, @rating, state_id(), state_score())
    new_score = evaluator.state_score
  end

  def update_score
    recorder = ScoreRecorder.new($DATABASE_NAME)
    recorder.update_score(state_id(), state_score())
    recorder.close()
  end

  def score_for_new_state
    # records the new state and passes it and it's id through tp StateEvaluator which will eventually return a score
    record_state()
    evaluator = StateEvaluator.new(@state, @rating, @new_state_id)
    evaluator.state_score
  end

  def record_state
    recorder = StateRecorder.new($DATABASE_NAME)
    @new_state_id = recorder.record_state_and_id(@state)
    recorder.close()
  end

  def get_recorded_state_info
    # creates a new score checker, gets it to return the recorded score value, and closes it immidiately to prevent connection leakage
    state_checker = StateChecker.new($DATABASE_NAME)
    @state_info = state_checker.state_info(@state)
    state_checker.close()
  end

  def state_is_fully_calculated?
    @state_info['fully_scored'] == 't'
  end

  def state_score
    @state_info['score'].to_i
  end

  def state_id
    @state_info['id'].to_i
  end
end
