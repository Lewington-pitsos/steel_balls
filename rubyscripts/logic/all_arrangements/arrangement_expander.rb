class ArrangementExpander

  @@weights = :heavier

  def self.weights
    @@weights
  end

  def self.weights=(value)
    @@weights = value
  end

end
