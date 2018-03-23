# generates and returns arrays of unmodified ball objects according to the passed in length or the number passed in to generate_balls


require_relative './ball'
require_relative '../ball_helper'
require_relative '../config'

class BallGenerator

  include BallHelper

  attr_reader :length

  def initialize(length=$DEFAULT_LENGTH)
    p $DEFAULT_LENGTH
    @length = length
  end

  def generate_balls(num=@length)
    arrangement = []
    num.times do
      arrangement << Ball.new()
    end
    arrangement
  end
end
