# This guy takes a single simplified selction order and associated possible arrangements.

# for every arrangemtn it generates a "balance state" which is just exactly the passed in ball arrangement, seperated into four categories:
# => unweighed balls (those not selected at all)
# => balanced balls (those balls that were weighed and balanced)
# => lighter balls (those that were weighed and came out on the lighter side)
# => heavier balls (those that were weighed and came out on the heavier side)

# each balance state is added to the origional passed in selection object

require './rubyscripts/logic/shared/ball_helper'
require './rubyscripts/logic/shared/state_generator'
require_relative './scale/balancer'
require_relative './scale/weigh_executer'


class Scale

  include BallHelper

  attr_accessor :selection_order, :arrangements

  def initialize
    @balancer = Balancer.new()
    @executor = WeighExecutor.new()
    @state_generator = StateGenerator.new()
    @arrangements = []
    @generated_state = {}
    @selection_order = {}
    @already_generated_states = []
  end

  def weigh(selection_order)
    @selection_order = selection_order
    @selection_order[:states] = []
    @already_generated_states = []
    generate_all_balance_states
  end

  private

  def generate_all_balance_states
    # for each selection, triggers a balance of that selection with ALL of the passed in ball arrangements
    @arrangements.each do |arrangement|
      apply_conversions(arrangement)
      record_if_new(@generated_state)
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

    arrangement = @executor.execute_weigh(balance_state)
    @generated_state = @state_generator.generate_state(arrangement)
  end

  def record_if_new(state)
    unless @already_generated_states.include?(state.to_s)
      @selection_order[:states] << state
      @already_generated_states << state.to_s
    end
  end
end
