require_relative '../lookup'

class TreeLookup < Lookup

  def build_tree
    first_id = state_id_by_values(first_state)
    @tree = build_state(first_id)
  end


  private

  def build_state(state_id)
    state = get_by_id(state_id, @@state_tab)
    selections = build_possible_selections(state_id)
    state['selections'] = selections
    state
  end

  def first_state
    {
      unknown: $DEFAULT_LENGTH,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    }
  end

    # ================ Query Methods ================

  def single_possible_selection(state_id)
    @db.exec(
      <<~CMD
        SELECT selection_id FROM #{@@possible_tab}
        WHERE state_id = #{state_id}
        LIMIT 1;
      CMD
    )
  end

  def state_id_by_values(state)
    @db.exec(
      <<~CMD
        SELECT * FROM scored_states
        WHERE unknown = #{state[:unknown]} AND
          possibly_lighter = #{state[:possibly_lighter]} AND
          possibly_heavier = #{state[:possibly_heavier]} AND
          normal = #{state[:normal]};
      CMD
    )[0]['id']
  end

end
