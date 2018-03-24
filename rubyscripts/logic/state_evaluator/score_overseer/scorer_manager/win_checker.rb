# takes in an array of rated selections

# checks all those weighted selections to see if any of them are winning selections (i.e. their rating is equal to (or somehow above) the winning rating)

# if there are any, it gives them all a score of 0 and returns them all in an array

# otherwise it returns an empty array

class WinChecker

  def initialize
    @winning_selections = []
  end

  def winners(rated_selections)
    # goes through every selection. Is winning, all infromation regarding it's states and rating is deleted and it's added to the winning selections list with a score of 0
    rated_selections.each do |selection|
      if winner?(selection)
        @winning_selections << { selection: selection[:selection], score: 0 }
      end
    end

    @winning_selections
  end

  private

  def winner?(selection)
    selection[:rating] >= ($WINNING_RATING || 37)
  end
end
