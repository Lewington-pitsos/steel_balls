# gets passed in a state and returns all the possible even-numbered permutations of ball arrangements, and each permutation is split in half

require_relative '../../shared/arrangement_generator'

class StatePermuter
  def initialize
    @arrangement_generator = ArrangementGenerator.new()
    @balls = []
  end

  private

  attr_accessor :balls

  def generate_arrangement(state)
    @balls = @arrangement_generator.marked_balls(state)
  end
end
