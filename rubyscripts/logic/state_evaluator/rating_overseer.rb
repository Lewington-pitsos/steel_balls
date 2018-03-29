# takes in a ball state and holds a captive Omni selector, a captive State expander and a captive RaterManager.

# It gets he Omni selector to generate all possible selection orders and the state expander to generate all possible ball arrangements.

# it then maps each selection order to a ball arrangement, we now have a Weigh Order.

# the Weigh Order is then rated, and the resulting Rated Weighed Selections are saved to a database and then returned.

require './rubyscripts/logic/shared/ball_helper'
require_relative './rating_overseer/omni_selector'
require_relative './rating_overseer/state_expander'
require_relative './rating_overseer/rater_manager'


class RatingOverseer

  include BallHelper

  attr_accessor :weigh_orders

  def initialize(state, rating, id)
    @state = state
    @rater = RaterManager.new(rating, id)
    @state_id = id
    @omni_selector = OmniSelector.new()
    @state_expander = StateExpander.new()
    @selection_orders = []
    @arrangements = []
    @rated_weighed_selections = []
  end

  def rated_weighed_selections
    generate_selections_to_weigh
    rate
  end

  private

  attr_accessor :arrangements, :selection_orders

  def generate_selections_to_weigh
    # gathers all the selection orders and arrangements. Merges them by adding a copy of each arrangement to each selection order, and then returns all the seletion orders
    get_all_selection_orders
    get_all_arranments
    merge
  end

  def get_all_selection_orders
    @omni_selector.get_all_possible_selections(@state)
    @selection_orders = @omni_selector.all_selections
  end

  def get_all_arranments
    @arrangements = @state_expander.expand(@state)
  end

  def merge
    # for each selection order, makes a deep clone of every arrangement in the ball arrangement's list and adds the whole cloned arrangeemnt list to the selection order
    @selection_orders.each do |order|
      order[:balls] = @arrangements.map do |arrangement|
        duplicate_balls(arrangement)
      end
    end
  end

  def rate
    @rated_weighed_selections = @rater.weighed_and_scored(@selection_orders)
  end
end
