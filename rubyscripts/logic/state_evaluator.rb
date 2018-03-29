# gets passed in  a state and it's rating

# passes the ball state to the selection overseer, which saves and then returns all Rated Weighed Selections
# passes the Rated Weighed Selections to the Scorer Manager which returns a score for each passed in Selections plus a new state score

# passes the state score, the state and all the scored selections to a new state saver instance, which saves all of it.

# finally, returns the state score to the state manager
require 'pry'
require './rubyscripts/logic/database/lookup'
require './rubyscripts/logic/database/score_recorder'
require_relative './state_evaluator/scorer_manager'
require_relative './state_evaluator/rating_overseer'
require_relative './database/info_saver'

class StateEvaluator

  def initialize(state, rating, id, score=999)
    @state = state
    @id = id
    @rating = rating
    @score = score
    @scorer = ScorerManager.new()
    @lookup = Lookup.new($DATABASE_NAME)
    @recorder = ScoreRecorder.new($DATABASE_NAME)
    @rated_weighed_selections = []
    @scored_state_info = []
    @fully_scored = false
  end

  def state_score
    get_rated_selections
    get_state_score
    save_scored_selections(@scored_state_info[:selections])
    save_state_score
    { score: @scored_state_info[:state_score], fully_scored: @fully_scored }
  end

  private

  def state_is_fully_scored?
    # the state is fully scored iff all rated_welections have been scored AND all scored selections have been fully scored
    @rated_weighed_selections.length == @scored_state_info[:selections].length &&
    @scored_state_info[:selections].all? do |selection|
      selection[:score][:fully_scored]
    end
  end

  def get_state_score
    @scored_state_info = @scorer.scored_selections(@rated_weighed_selections)
  end

  def get_rated_selections
    if @score != 999
      @rated_weighed_selections = recorded_rated_selections
    else
      @rated_weighed_selections = new_rated_selections
    end
  end

  def save_scored_selections(selections)
    # saves all the selections
    selections.each do |selection|
      @recorder.update_score(selection[:id], selection[:score][:score], 'possible_selections')
    end
  end

  def save_state_score
    # works out the lowest score for the current state and whether or not that score has been fully calculated and updates the appropriate scored_states row
    score = [@scored_state_info[:state_score], @score].min
    @fully_scored = state_is_fully_scored?
    @recorder.update_state_score(@id, score, @fully_scored)
  end

  def new_rated_selections
    rater = RatingOverseer.new(@state, @rating, @id)
    rater.rated_weighed_selections
  end

  def recorded_rated_selections
    @lookup.build_selections(@id)
  end
end
