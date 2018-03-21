# basically has a captive ShoverManager. on command it orders the ShoverManager to generate a new shover state, turns it into a simple ball state objct, and stores and returns it.

require_relative './selection_side_generator/shover_manager'

class SelectionSideGenerator
  attr_accessor :all_selections

  def initialize(ball_state, balls_requested)
    # adds the default selection (generated just by adding shovers) to the list of all selections
    @all_selections = []
    @shover_manager = ShoverManager.new(ball_state, balls_requested)
    generate_selection()
  end

  def next_selection
    # keeps generating selections, adding them to the selections list and returning them
    # returns the false
    if @shover_manager.shove
      generate_selection()
      @all_selections[-1]
    else
      false
    end
  end

  private

  def generate_selection
    # modifies the defaulot selection by adding one ball to the order from one mark category for each shover "pointing at" that category
    selection_order = default_order()

    @shover_manager.state.each do |shover|
      selection_order[shover.mark] += 1
    end

    @all_selections << selection_order
  end

  def default_order
    {
      normal: 0,
      possibly_lighter: 0,
      possibly_heavier: 0,
      unknown: 0,
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
