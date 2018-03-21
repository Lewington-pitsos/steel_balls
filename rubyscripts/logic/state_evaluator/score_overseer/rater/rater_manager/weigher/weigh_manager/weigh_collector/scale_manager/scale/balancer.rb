# takes in a SINGLE ball arrangement and an associated selection and returns a single balance state

# a "balance state" is just exactly the passed in ball arrangement, seperated into four categories:
# => unweighed balls (those not selected at all)
# => balanced balls (those balls that were weighed and balanced)
# => lighter balls (those that were weighed and came out on the lighter side)
# => heavier balls (those that were weighed and came out on the heavier side)

# the original ball arrangement passed in is destroyed in the process

class Balancer

  def initialize

  end

  def balance(selection_order, balls)
    @balls = balls
    categorize_balls
    @left = gather_balls(selection_order[:left])
    @right = gather_balls(selection_order[:right])
    balance
  end

  def categorize_balls
    @categories = Hash.new { |h, k| h[k] = [] }
    # a hash with different arrays as default values

    @balls.each do |ball|
      categories[ball.mark] << ball
    end
  end

  def gather_balls(order)
    to_weigh = []

    order.each do |mark, number|
      number.times do
        to_weigh << @categories[mark]
      end
    end
  end

  def balance

  end

end
