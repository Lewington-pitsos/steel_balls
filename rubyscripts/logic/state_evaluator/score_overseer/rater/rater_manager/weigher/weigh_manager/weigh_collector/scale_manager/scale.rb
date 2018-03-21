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
require_relative '../../../../../../../../shared/state_generator'

class Scale

  include BallHelper

  attr_accessor :selecion_order

  def initialize
    @balancer = Balancer.new()
    @executor = WeighExecutor.new()
    @state_generator = StateGenerator.new()
    @arrangements = []
    @generated_state = {}
  end

  def weigh(selection_order)
    @selecion_order = selecion_order
    @selecion_order[:balances] = []
    generate_all_balance_states
  end

  def generate_all_balance_states
    # for each selection, triggers a balance of that selection with ALL of the passed in ball arrangements
    @selection_order[:balls].each do |arrangement|
      apply_conversions(arrangement)
      @selection_order[:balances] << @generated_state
    end
  end

  def apply_conversions(arrangement)
    # first we create a clone of the ball arrangement
    # then we weigh the selection against that cloned ball arrangement and create a balance state
    # then we convert that into an altered arragmenet based on weigh results
    # then we convert that arrangeemnt into a normal ball state and save it
    balls = duplicate_balls(arrangement)
    @balancer.balance(@selection_order, balls)
    balance_state = @balancer.balance_state
    
    arrangement = @executor.weigh(balance_state)
    @generated_state = @state_generator.generate_state(state)
  end
end
