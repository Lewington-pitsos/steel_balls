require_relative '../lookup'

class TreeLookup < Lookup

  private

  def build_state(state_id)
    state = get_by_id(state_id, @@state_tab)
    selections = build_possible_selections(state_id)
    state['selections'] = selections
    state
  end

end
