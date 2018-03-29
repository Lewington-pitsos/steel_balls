require_relative '../lookup'

class SelectionLookup < Lookup

  attr_reader :all_selections

  def initialize(name=@@database_name)
    super(name)
    @all_selections = []
  end

  def build_all_selections(id)
    @selections = build_possible_selections(id)
  end

  def build_state(state_id)
    state = get_by_id(state_id, @@state_tab)
    state
  end

end
