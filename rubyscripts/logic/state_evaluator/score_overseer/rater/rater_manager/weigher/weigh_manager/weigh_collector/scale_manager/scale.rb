# This guy takes a single simplified selction order and associated possible arrangements.

# for every arrangemtn it generates a "balance state" which is just exactly the passed in ball arrangement, seperated into four categories:
# => unweighed balls (those not selected at all)
# => balanced balls (those balls that were weighed and balanced)
# => lighter balls (those that were weighed and came out on the lighter side)
# => heavier balls (those that were weighed and came out on the heavier side)

# finally it returns an array of balance states

require_relative './scale/balancer'
require_relative '../../../../../../../shared/ball_helper'

class Scale

  include BallHelper

  def initialize
    @balancer = Balancer.new()
    @left = {}
    @right = {}
    @arrangements = []
  end

  def weigh(selection_order)
    @left = selecion_order[:left]
    @right = selection_order[:right]
    @arrangements = selecion_order[:balls]
  end

  def generate_all_balance_states
    # for each selection, triggers a balance of that selection with ALL of the passed in ball arrangements
    @arrangements.each do |arrangement|
      balls = duplicate_balls(arrangement)
      @balancer.balance(selection, balls)
    end
  end

end
