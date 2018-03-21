
require_relative './scale_manager/scale'

class ScaleManager

  attr_reader :selections

  def initialize
    @scale = Scale.new()
    @selections = []
    @left = {}
    @right = []
  end

  def weigh(selection_order)
    parse_selection_order(selection_order)
    generate_all_selections
    weigh_all_selections
  end

  private

  def parse_selection_order(selection_order)
    @selections = []
    @selections_to_rate = []
    @left = selection_order[:left]
    @right = selection_order[:right]
    @arrangements = selection_order[:balls]
  end

  def generate_all_selections
    # for each selection in the list of possible selections for the right side of the weigh, we add a new simple selection object (also including the single selection for the left side) to the list of all simple selections
    @right.each do |selection|
      @selections << { left: @left, right: selection }
    end
  end

  def weigh_all_selections
    # for each selection generated we ask the scale to weigh that selection, passing in the original arrangements object for weighing each time
    @scale.arrangements = @arrangements
    @selections.each do |selection_order|
      @scale.weigh(selection_order)
    end
  end

end
