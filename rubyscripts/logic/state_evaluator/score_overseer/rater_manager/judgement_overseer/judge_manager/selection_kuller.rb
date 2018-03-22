# gets passed in a minimum rating and an array of scored selections.
# It returns a new array that copies the passed in one exactly except that any selection whose score is equal to or lower (i think lower is impossible though) than the passed in rating is stricken from the new array.

class SelectionKuller

  def initialize(minimum_rating)
    @min = minimum_rating
  end

  def kulled(selections)
    selections.select do |selection|
      selection[:rating] > @min
    end
  end

end
