# generates every possible permutations of selections  for one side of a scale

require_relative './selection_generator/shover_manager'

class SelectionGenerator
  attr_accessor :all_selections

  def initialize
    @all_selections = []
  end

  def generate_all_selections(ball_state, balls_requested)
    # sets up a new shover manager object, records the default state of the shover manager as the first selection order and then starts recursive generation of all further selection orders
    @balls_requested = balls_requested
    @shover_manager = ShoverManager.new(ball_state, balls_requested)
    generate_selection
    generate_next_selection
  end

  def generate_next_selection
    # keeps generating selections and adding them to the selections list
    # returns the selections list as soon as a seleciton fails
    if @shover_manager.shove
      generate_selection
      generate_next_selection
    else
      return @all_selections
    end
  end

  def generate_selection
    # modifies the defaulot selection by adding one ball to the order from one mark category for each shover "pointing at" that category
    # the first half of these are added to the right, the rest to the left. Because the deviding is consistant ( and a weigh whose left and right sides are swapped is equivelent to the un-swapped weigh ), we should cover all possible weighs
    selection_order = self.default_order
    half_balls = @balls_requested / 2
    side = :left

    @shover_manager.state.each_with_index do |shover, index|
      if index >= half_balls
        side = :right
      end
      selection_order[side][shover.mark] += 1
    end

    @all_selections << selection_order
  end

  def default_order
    {
      left: {
        normal: 0,
        not_lighter: 0,
        not_heavier: 0,
        unknown: 0,
      },

      right: {
        normal: 0,
        not_lighter: 0,
        not_heavier: 0,
        unknown: 0,
      }
    }
  end
end


=begin
state = {
  normal: 0,
  not_lighter: 0,
  not_heavier: 0,
  unknown: 8
}

gen = SelectionGenerator.new()

gen.generate_all_selections(state, 4)
puts gen.all_selections
puts gen.all_selections.length
=end
