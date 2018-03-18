# gets passed in a state and returns all the possible even-numbered permutations of ball arrangements, and each permutation is split in half

require_relative '../../shared/arrangement_generator'

class StatePermuter
  def initialize
    @arrangement_generator = ArrangementGenerator.new()
    @perms = []
  end

  private

  def permute_state(state)
    # we generate a ball arrangement that matches the state
    @perms = []
    balls = generate_arrangement(state)
    generate_all_permutations(balls)
    split_permutations
    @perms
  end

  attr_accessor :balls, :perms

  def generate_arrangement(state)
    @arrangement_generator.marked_balls(state)
  end

  def generate_all_permutations(balls)
    # generates all permutations of the balls array of all even lengths
    # all permutations reference the EXACT SAME ball objects but this is ok because we never modify any of them
    #NOTE: THIS DOES NOT WORK. permutations take waaaay too long to calculate. Alternative soloution pending.
    for num in (2..balls.length).step(2)
      @perms.concat(balls.permutation(num).to_a)
    end
  end

  def split_permutations
    # splits every permutation in half
    @perms = @perms.map do |perm|
      [perm[0... perm.length / 2], perm[perm.length / 2.. -1]]
    end
  end
end
