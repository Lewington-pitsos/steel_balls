# takes in a ball state and holds a captive Omni selector and a captive State expander. It gets he Omni selector to generate all possible selection orders and the state expander to generate all possible ball arrangements. it then maps each selection order to a ball arrangement, and returns this huge agglomoration.

require_relative './selection_overseer/omni_selector'
require_relative './selection_overseer/state_expander'
require_relative '../shared/ball_helper'

class SelectionOverseer

  include BallHelper

  attr_accessor :weigh_orders

  def initialize(state)
    @state = state
    @omni_selector = OmniSelector.new()
    @state_expander = StateExpander.new()
    @selection_orders = []
    @arrangements = []
    @weigh_orders = []
  end

  def selections_to_weigh
    # gathers all the selection orders and arrangements. Merges them by adding a copy of each arrangement to each selection order, and then returns all the seletion orders
    get_all_selection_orders
    get_all_arranments
    merge
    @selection_orders
  end

  private

  attr_accessor :arrangements, :selection_orders

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
end
