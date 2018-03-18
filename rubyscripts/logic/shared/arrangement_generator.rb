# generates and returns arrays of unmodified ball objects according to the passed in length or the number passed in to generate_balls


require_relative './ball'

class ArrangementGenerator

  attr_reader :length

  @@default_length = 8

  def initialize(length=@@default_length)
    @length = length
  end

  def generate_balls(num=@length)
    Array.new(num, Ball.new())
  end

end
