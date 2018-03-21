# takes in a SINGLE ball arrangement and an associated selection and returns a single balance state

# a "balance state" is just exactly the passed in ball arrangement, seperated into four categories:
# => unweighed balls (those not selected at all)
# => balanced balls (those balls that were weighed and balanced)
# => lighter balls (those that were weighed and came out on the lighter side)
# => heavier balls (those that were weighed and came out on the heavier side)

# the original ball arrangement passed in is destroyed in the process

require_relative './balancer/comparer'
require_relative './scale_helper'

class Balancer

  include ScaleHelper

  attr_accessor :balance_state

  def initialize
    @comparer = Comparer.new()
    @categories = []
    @balance_state = []
  end

  def balance(selection_order, balls)
    @balls = balls
    categorize_balls
    @left = gather_balls(selection_order[:left])
    @right = gather_balls(selection_order[:right])
    compare
  end

  private

  attr_reader :categories
  attr_writer :balls

  def categorize_balls
    # splits the passed in ball array into a hash of arrays, each containing all and only the balls of a given mark
    @categories = Hash.new { |h, k| h[k] = [] }
    # a hash with different arrays as default values

    @balls.each do |ball|
      categories[ball.mark] << ball
    end
  end

  def gather_balls(order)
    # for each mark in the passed in order (a ball state) we take that many balls of that mark out of the categories hash and put them into an array
    # we then return the array
    to_weigh = []

    order.each do |mark, number|
      number.times do
        to_weigh << @categories[mark].pop()
      end
    end

    to_weigh
  end

  def compare
    @comparer.weigh_balls(@left, @right)
    @balance_state = default_balance_state

    @balance_state[:balanced] = @comparer.balanced
    @balance_state[:heavier] = @comparer.heavier
    @balance_state[:lighter] = @comparer.lighter
    @balance_state[:unweighed] = agglomorate(@categories)

  end

  def default_balance_state
    {
      unweighed: [],
      lighter: [],
      heavier: [],
      balanced: []
    }
  end
end
