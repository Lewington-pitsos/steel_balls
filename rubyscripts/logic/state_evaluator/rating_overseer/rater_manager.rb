# takes a whole huge bunch of complex selection orders
# these are hashes composed of:
# => a single right selectioin
# => an array of left selections
# => an array of possible ball arrangements

# and a minimum_rating

# each selection order is weighed (weigher) then rated based on the weigh and all selections rated lower than the minimum are removed

# the result is returned

require_relative './rater_manager/judgement_overseer/judge_manager'
require_relative './rater_manager/weigher/weigh_collector'

class RaterManager

  def initialize(minimum_rating)
    @judgement_overseer = JudgeManager.new(minimum_rating)
    @weigher = WeighCollector.new()
  end

  def weighed_and_scored(weigh_order)
    @weigher.collect_all_weighs(weigh_order)
    @judgement_overseer.scored_and_kulled(@weigher.weighed_selections)
  end

end
