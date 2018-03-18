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
