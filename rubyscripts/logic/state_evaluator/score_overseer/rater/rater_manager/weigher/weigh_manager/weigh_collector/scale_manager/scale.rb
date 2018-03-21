# This guy takes a single simplified selction order and associated possible arrangements.

# for every arrangemtn it generates a "balance state" which is just exactly the passed in ball arrangement, seperated into four categories:
# => unweighed balls (those not selected at all)
# => balanced balls (those balls that were weighed and balanced)
# => lighter balls (those that were weighed and came out on the lighter side)
# => heavier balls (those that were weighed and came out on the heavier side)

# each balance state is added to the origional passed in selection object

require_relative './scale/balancer'
require_relative './scale/weigh_executer'
require_relative '../../../../../../../../shared/ball_helper'

class Scale

  include BallHelper

  attr_accessor :selecion_order

  def initialize
    @balancer = Balancer.new()
    @executor = WeighExecutor.new()
    @arrangements = []
  end

  def weigh(selection_order)
    @selecion_order = selecion_order
    @selecion_order[:balances] = []
    generate_all_balance_states
  end

  def generate_all_balance_states
    # for each selection, triggers a balance of that selection with ALL of the passed in ball arrangements
    @selection_order[:balls].each do |arrangement|
      balls = duplicate_balls(arrangement)
      @balancer.balance(@selection_order, balls)
      balance_state = @balancer.balance_state
      arrangement = @executor.weigh(balance_state)
    end
  end
end
