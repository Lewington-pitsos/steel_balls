
# gets passed in a weigh result (an array of selections mapped to states) and a minimum rating.
# rates all the states, and selections, and then returns a new, rated weigh result with all the selections with ratigns lower than the mimimum removed.

require_relative './judge_manager/selection_kuller'
require_relative './judge_manager/judge'

class JudgeManager

  def initialize(minimum)
    @kuller = SelectionKuller.new(minimum)
    @judge = Judge.new()
  end

  def scored_and_kulled(weigh_result)
    @judge.rate_selections(weigh_result)
    @kuller.kulled(weigh_result)
  end
end
