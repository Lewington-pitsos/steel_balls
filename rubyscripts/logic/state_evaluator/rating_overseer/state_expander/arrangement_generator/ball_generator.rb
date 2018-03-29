# generates and returns arrays of unmodified ball objects according to the passed in length or the number passed in to generate_balls

require './rubyscripts/logic/shared/ball_helper'
require_relative './ball_generator/ball'


class BallGenerator

  include BallHelper

  attr_reader :length

  def initialize(length=$DEFAULT_LENGTH)
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
