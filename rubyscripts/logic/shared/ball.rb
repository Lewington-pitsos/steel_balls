# each ball has a weight and an id
# balls can also be marked to specify their state

# there are 4 states balls can be in
# => unknown (could be heavier, lighter or normal weight)
# => normal (we know FOR SURE that this ball's weight is normal)
# => not_heavier (we know FOR SURE that this ball's weight is not heavier, but it COULD still be lighter)
# => not_lighter (same but Vise Versa)

# These four states are mutually exlcusive. No ball can be in 2 at once, so each ball can only have one mark

# balls handle their own marking and draw some basic conclusions


class Ball

  attr_reader :weight
  attr_accessor :mark

  @@default_mark = :unknown

  @@normal_weight = 1
  @@light_weight = 0
  @@heavy_weight = 2

  def initialize(mark=@@default_mark, weight=@@normal_weight)
    @weight = weight
    @mark = mark
  end

  def make_heavier
    @weight = @@heavy_weight
  end

  def make_lighter
    @weight = @@light_weight
  end
end
