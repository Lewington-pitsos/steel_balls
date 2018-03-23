require_relative './state_manager'


class Interface

  @@default_rating = 0

  def initialize
    request_starting_state
  end

  def request_starting_state
    puts "========================[ STEEL BALL CALCULATOR ] ========================\n\n\n"
    puts 'Welcome to Steel Ball Calculator®. Please enter the number of balls you would like to weigh:'
    puts 'Ball Number:'

    number = gets.to_i
    state = generate_state(number)

    puts "\nThank you, we will now calculate the number of weighs it will take for know, for certain which ball is differently weighted\n"
    puts "Calculating...\n"
    score = calculate_state_score(state)
    puts "\nSuccess! Steel Ball Calculator® has calculated that you will need only #{score} weighs to determine the odd ball cor certain\n\n"
    puts "========================[ END OF PROGRAM ] ========================\n\n\n"
  end

  def generate_state(num)
    {
      unknown: num,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    }
  end

  def calculate_state_score(state)
    StateManager.new({ state: state, rating: @@default_rating }).score
  end
end

Interface.new()
