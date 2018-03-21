# This guy takes a single simplified selction order and associated possible arrangements.

# for every arrangemtn it generates a "balance state" which is just exactly the passed in ball arrangement, seperated into four categories:
# => unweighed balls (those not selected at all)
# => balanced balls (those balls that were weighed and balanced)
# => lighter balls (those that were weighed and came out on the lighter side)
# => heavier balls (those that were weighed and came out on the heavier side)

# finally it returns an array of balance states

require_relative './scale/balancer'
require_relative '../../../../../../../../shared/ball_helper'

class Scale

  include BallHelper

  attr_accessor :selecion_order

  def initialize
    @balancer = Balancer.new()
    @selection_order = {}
    @left = {}
    @right = {}
    @arrangements = []
  end

  def weigh(selection_order)
    @selecion_order = selecion_order
    @arrangements = @selecion_order[:balls]
    @selecion_order[:balances] = []
    generate_all_balance_states
  end

  def generate_all_balance_states
    # for each selection, triggers a balance of that selection with ALL of the passed in ball arrangements
    @arrangements.each do |arrangement|
      balls = duplicate_balls(arrangement)
      @balancer.balance(@selection_order, balls)
      @selection_order[:balances] << @balancer.balance_state
    end
  end

end
