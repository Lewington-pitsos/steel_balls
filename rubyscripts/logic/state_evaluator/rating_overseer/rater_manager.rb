# takes a whole huge bunch of complex selection orders
# these are hashes composed of:
# => a single right selectioin
# => an array of left selections
# => an array of possible ball arrangements

# and a minimum_rating

# each selection order is weighed (weigher) then rated based on the weigh and all selections rated lower than the minimum are removed

# the result is returned

require './rubyscripts/logic/database/info_saver'
require_relative './rater_manager/judgement_overseer/judge_manager'
require_relative './rater_manager/weigher/weigh_collector'

class RaterManager

  def initialize(minimum_rating, state_id=1)
    @judgement_overseer = JudgeManager.new(minimum_rating)
    @weigher = WeighCollector.new()
    @saver = InfoSaver.new()
    @state_id = state_id
  end

  def weighed_and_scored(weigh_order)
    # first we conert the complex selection orders from the passed in weigh order into simple selection orders, and map each to all the ball arrangements in the weigh order
    # We then actually weigh the ball arrangements according to the associated simple selections
    # lastly we save ALL the results of this weigh and return as many of them as BREADTH demands
    @weigher.collect_all_weighs(weigh_order)
    rated_weighed_selections = @judgement_overseer.scored_and_kulled(@weigher.weighed_selections)
    @saver.save_everything(rated_weighed_selections, @state_id)
    rated_weighed_selections[0.. $BREADTH]
  end

end
