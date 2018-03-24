require_relative './state_manager'
require './rubyscripts/logic/database/lookup'
require_relative './state_evaluator/selection_overseer/state_expander/arrangement_generator/ball_generator'
require 'active_support/core_ext/hash'

class Interface

  def initialize(run=true)
    @length = 0
    @lookup = Lookup.new()
    request_starting_state if run
  end

  def request_starting_state
    puts "========================[ STEEL BALL CALCULATOR ] ========================\n\n\n"
    puts 'Welcome to Steel Ball Calculator®. Please enter the number of balls you would like to weigh:'

    request

    puts "========================[ END OF PROGRAM ] ========================\n\n\n"
  end

  private

  attr_accessor :length

  def request
    puts 'Ball Number:'

    @length = gets.to_i
    proceed_if_valid
  end

  def calculate
    state = generate_state
    setup_defaults

    puts "\nThank you, we will now calculate the number of weighs it will take for know for certain which ball is differently weighted\n"
    puts "Calculating...\n"

    score = calculate_state_score(state)

    puts "\nSuccess! Steel Ball Calculator® has calculated that you will need only #{score} weighs to determine the odd ball for certain\n\n\n\n"

    puts "========================[ TREE DATA ] ========================\n\n\n"
    @lookup.build_tree
    puts @lookup.tree.to_xml
  end

  def proceed_if_valid
    if valid?
      calculate
    else
      request
    end
  end

  def valid?
    if @length <= 1 || @length == 2
      if @length == 1
        puts "Hardy har har Mr. Comedian. Try again please.\n\n"
      else
        puts "Funnily enough this isn't even possible, think about it...\n\n"
      end
      false
    else
      true
    end
  end

  def setup_defaults
    set_winning_rating
    set_deafult_length
  end

  def set_winning_rating
    $WINNING_RATING = @length * $NORMAL_SCORE - ($NORMAL_SCORE - $HALF_SCORE)
  end

  def set_deafult_length
    $DEFAULT_LENGTH = @length
  end

  def generate_state
    {
      unknown: @length,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    }
  end

  def calculate_state_score(state)
    StateManager.new({ state: state, rating: $DEFAULT_RATING }).score
  end
end
