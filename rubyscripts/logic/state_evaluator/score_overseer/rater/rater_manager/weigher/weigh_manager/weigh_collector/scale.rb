# This guy takes a single simplified selction order and associated possible arrangements.

# he weighs every arrangement and makes alterations to it based on how the weigh turend out

# finally he returns every arrangement (now presumably altered)

class Scale

  def initialize

  end

  def weigh(selection_order)
    @left = selecion_order[:left]
    @right = selection_order[:right]
    @balls = selecion_order[:balls]

  end

end
