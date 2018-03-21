# Takes in a ball state representing the balls from which selections can be genrated
# keeps on being passed in integers representing the number of balls to select for each side. For each integer passed in it generates all possible selection orders, shoves them to an array and returns that array.

# A selection order is made up of:
# => a state representing the balls to select for the left side of the weigh
# => an array of all the possible selections that could be made for the right side of the weigh, given that no ball already selected for the left side can also be weighed against iself on the right side

require_relative './whole_selection_generator/selection_side_generator'

class WholeSelectionGenerator

  attr_reader :all_selections

  def initialize(state)
    @to_select = 0
    @state = state
    @left = nil
    @all_selections = []
  end

  def generate_all_selections(number)
    # empties the list of all selections, sets the selection number and creates a @left selection side generator
    # generates all selections possible given those presets and returns them
    @all_selections = []
    @to_select = number
    @left = SelectionSideGenerator.new(@state, @to_select)
    generate_next_left_selections
    @all_selections
  end

  private

  def generate_left_selections
    # untill the next attempt at genrating a selection fails
    # => we generate a selection, and then generate all selections of the same length possible with the balls NOT selected for that selection.
    # => we then add a "selection order" to the list of selection orders
    while selection = next_selection(@left)
      leftovers = leftover_state(selection)
      right_selections = all_right_selections(leftovers)
      @all_selections << { left: selection, right: right_selections }
    end
  end

  def next_selection(selection_generator)
    selection_generator.next_selection
  end

  def all_right_selections(state)
    # we create a new selection side generator using the passed in state, generate all the selections possible through it and return them
    right = SelectionSideGenerator.new(state, @to_select)

    all_selections = []

    while selection = next_selection(right)
      all_selections << selection
    end

    all_selections
  end

  def leftover_state(selection)
    # takes all the numbers in selection away from the appropriate marks on state, leaving us with a state of un-selected balls
    leftover_state = state_clone

    selection.each do |mark, num|
      leftover_state[mark] -= num
    end

    leftover_state
  end

  def state_clone
    # produces a shallow clone of the state. Alterations to this won't effect the actual state
    @state.dup
  end

end
