# basically has a captive ShoverManager. on command it orders the ShoverManager to generate a new shover state, turns it into a simple ball state objct, and stores and returns it.

require_relative './selection_side_generator/shover_manager'

class SelectionSideGenerator
  attr_accessor :all_selections

  def initialize(ball_state, balls_requested)
    @all_selections = []
    @shover_manager = ShoverManager.new(ball_state, balls_requested)
    @first = true
  end

  def next_selection
    # if this is the first time a selection is requested we return the default selection based on the state generated simply by creating the shovers. Otherwise we generate the next state and return it.
    # NOTE: the default selection must always be poissible, so there's no fear of returning it without checking if it is a legitimate selection
    if @first
      @first = false
      current_selection
    else
      find_next_selection
    end
  end

  private

  def find_next_selection
    # keeps generating selections, adding them to the selections list and returning them
    # returns the false
    if @shover_manager.shove
      current_selection
    else
      false
    end
  end

  def current_selection
    # generates a seleciton using the current shover manager state, adds it to the list and returns it
    generate_selection()
    @all_selections[-1]
  end

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
