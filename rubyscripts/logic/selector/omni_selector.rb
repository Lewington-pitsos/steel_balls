# the selection generator can only create all the selections for one (set) given number of balls at a time. the OmniSelector just asks the selection generator to generate selections for all the numbers of balls that can be made into weighs (i.e. all even numbers equal or less than the total number of balls) and exposes these

require_relative './omni_selector/whole_selection_generator'

class OmniSelector

  attr_reader :all_selections

  def initialize
    @generator = nil
    @all_selections = []
    @requestable_numbers = []
  end

  def get_all_possible_selections(state)
    # is passed in a ball state and the total number of balls and returns all the possible selection orders given that state
    set_up_generator(state)
    @requestable_numbers.each do |num|
      @generator.generate_all_selections(num)
    end
    @all_selections.concat(all_generated_selections)
  end


  private

  def set_up_generator(state)
    @all_selections = []
    @generator = WholeSelectionGenerator.new(state)
    @requestable_numbers = weighable_ball_numbers(state)
  end

  def all_generated_selections
    @generator.all_selections
  end


  def weighable_ball_numbers(state)
    # works out the total number of balls in the state and returns all the even numbers equal or below it
    total = state.inject(0) { |sum, arry| sum + arry[-1] }
    (1.. total / 2).to_a
  end

end

=begin
state = {
  normal: 2,
  not_lighter: 2,
  not_heavier: 2,
  unknown: 8
}

om = OmniSelector.new

om.get_all_possible_selections(state)

puts om.all_selections
puts om.all_selections.length
=end
