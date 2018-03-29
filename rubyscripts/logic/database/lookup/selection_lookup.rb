require_relative '../lookup'

class SelectionLookup < Lookup

  attr_reader :all_selections

  def initialize(name=@@database_name)
    super(name)
    @all_selections = []
  end

  def build_all_selections(id)
    @all_selections = build_possible_selections(id)
  end

  def build_state(state_id)
    state = {}
    state[:state] = get_by_id(state_id, @@state_tab)
    state[:rating] = state[:state].delete('rating')
    state
  end

  def get_full_selections(state_id)
    possible_selections(state_id)
  end

end
