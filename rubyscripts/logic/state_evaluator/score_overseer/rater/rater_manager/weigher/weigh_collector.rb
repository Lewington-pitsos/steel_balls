# this guy gets passed in a whole huge bunch of complex selection orders
# these are hashes composed of:
# => a single right selectioin
# => an array of left selections
# => an array of possible ball arrangements

# for each order passed in, the WeighCollector gets the scale manager to generate a bunch of simple selections and weigh each against the passed in ball arrangement.

# The scale_manager should pass back these simple selections, each mapped to all the UNIQUE ball states resulting from weighing each selection against that selection

# All of these are then gathered into a big array of weighed selections

require_relative './weigh_collector/scale_manager'

class WeighCollector

  attr_accessor :weighed_selections

  def initialize
    @scale_manager = ScaleManager.new()
    @weighed_selections = []
  end

  def collect_all_weighs(all_selection_orders)
    @weighed_selections = []
    all_selection_orders.each do |selection_order|
      @scale_manager.weigh(selection_order)
      @weighed_selections += @scale_manager.selections
    end
  end
end
