require_relative '../lookup'

class SelectionLookup < Lookup

  attr_reader :all_selections

  def initialize(name=@@database_name)
    super(name)
    @all_selections = []
    @state_id = 1
  end

  def build_all_selections(id)
    @state_id = id
    @all_selections = build_possible_selections(@state_id)
  end

  def build_state(state_id)
    state = {}
    state[:state] = symbolized(get_by_id(state_id, @@state_tab))
    state[:rating] = state[:state].delete(:rating)
    state[:state].delete(:fully_scored)
    state[:state].delete(:score)
    state
  end

  def build_selection(id)
    selection = symbolized(get_by_id(id, @@selection_tab))
    selection[:right] = symbolized(get_side(selection.delete(:right_id)))
    selection[:left] = symbolized(get_side(selection.delete(:left_id)))
    selection[:states] = build_resulting_states(id)
    {
      rating: selection_rating(id),
      selection: selection,
      id: id.to_i
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

  # ================ Query Methods ================

  def selection_rating(selection_id)
    @db.exec(<<~CMD
        SELECT rating FROM possible_selections
        WHERE state_id = #{@state_id} AND selection_id = #{selection_id};
      CMD
    )[0]['rating'].to_i
  end

end
