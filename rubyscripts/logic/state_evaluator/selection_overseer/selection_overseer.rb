# takes in a ball state and holds a captive Omni selector and a captive State expander. It gets he Omni selector to generate all possible selection orders and the state expander to generate all possible ball arrangements. it then maps each selection order to a ball arrangement, and returns this huge agglomoration.

require_relative './selector/omni_selector'
require_relative './all_arrangements/state_expander'
require_relative '../../shared/ball_helper'
class SelectionOverseer

  include BallHelper

  def initialize(state)
    @state = state
    @omni_selector = OmniSelector.new()
    @state_expander = StateExpander.new()
    @selection_orders = []
    @arrangements = []
    @weigh_orders = []
  end

  def selections_to_weigh
    get_all_selection_orders
    get_all_arranments
    merge

  end

  private

  def get_all_selection_orders
    @omni_selector.get_all_possible_selections(@state)
    @selection_orders = @omni_selector.all_selections
  end

  def get_all_arranments
    @arrangements = @state_expander.expand(@state)
  end

  def merge
    @selection_orders.each do |order|
      order[:balls] =
    end
  end
end
