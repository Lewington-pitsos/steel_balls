# This guy takes a single simplified selction order and associated possible arrangements.

# for every arrangemtn it generates a "balance state" which is just exactly the passed in ball arrangement, seperated into four categories:
# => unweighed balls (those not selected at all)
# => balanced balls (those balls that were weighed and balanced)
# => lighter balls (those that were weighed and came out on the lighter side)
# => heavier balls (those that were weighed and came out on the heavier side)

# finally it returns an array of balance states

class Scale

  def initialize

  end

  def weigh(selection_order)
    @left = selecion_order[:left]
    @right = selection_order[:right]
    @balls = selecion_order[:balls]

  end

end
