# gets passed in an array of rated selections mapped to rated states

# first it checks if any selectors are winners.

# => If there are any winners, these are all scored at 0, and used to make an array of scored selection objects. The score for the sate is set to 1.

# => otherwise the array of rated selections is passed to the selection manager, which eventually passes back a scored selection hash for each rated selection passed in. In this case the state score is set to the lowest scored selection + 1.

# returns the score for the current state and an array of scored selection hashes

require_relative './scorer_manager/win_resolver'
require_relative './scorer_manager/win_checker'
require_relative './scorer_manager/selection_manager'

require 'pry'

class ScorerManager

  def initialize
    @checker = WinChecker.new()
    @resolver = WinResolver.new()
    @selection_manager = SelectionManager.new()
  end

  def scored_selections(rated_selections)

    scored_selections = score_all(rated_selections)
    state_score = @resolver.state_score(scored_selections)
    {selections: scored_selections, state_score: state_score}
  end

  private

  def score_all(rated_selections)
    winners = @checker.winners(rated_selections)
    if winners.any?
      winners
    else
      @selection_manager.score_all_selections(rated_selections)
    end
  end
end
