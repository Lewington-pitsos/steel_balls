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
    state[:state] = symbolized(get_by_id(state_id, @@state_tab))
    state[:rating] = state[:state].delete(:rating)
    state
  end

  def build_selection(id)
    selection = symbolized(get_by_id(id, @@selection_tab))
    selection[:right] = symbolized(get_side(selection.delete(:right_id)))
    selection[:left] = symbolized(get_side(selection.delete(:left_id)))
    selection[:states] = build_resulting_states(id)
    {
      selection: selection
    }
  end


  def get_full_selections(state_id)
    possible_selections(state_id)
  end

  def symbolized(hash)
    hash.inject({}) do |memo, (k, v)|
      memo[k.to_sym] = rubified_value(v); memo
    end
  end

  def rubified_value(value)
    if value == 't'
      true
    elsif value == 'f'
      false
    else
      value.to_i
    end
  end

end
