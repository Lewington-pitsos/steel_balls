require_relative '../lookup'

class SelectionLookup < Lookup

  attr_reader :all_selections

  def initialize(name=@@database_name)
    super(name)
    @all_selections = []
  end

end
