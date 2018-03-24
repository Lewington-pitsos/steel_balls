require_relative './archivist'

class Lookup < Archivist

  @@selection_tab = 'selections'
  @@side_tab = 'selection_sides'
  @@state_tab 'scored_states'
  @@optimal_tab = 'optimal_selections'
  @@resulting_tab = 'resulting_states'

  def initialize(name=@@database_name)
    super(name)
    @tree = {}
    @current = nil
  end

  def build_tree
    @tree = state_by_values(first_state)
  end

  def state_by_values(state)
    @db.exec(
      <<~CMD
        SELECT * FROM scored_states
        unknown = #{state[:unknown]} AND
          possibly_lighter = #{state[:possibly_lighter]} AND
          possibly_heavier = #{state[:possibly_heavier]} AND
          normal = #{state[:normal]};
      CMD
    )[0]
  end

  def build_selections(id)
    selections = get_by_id(id, @@selection_tab)
    selections.each do |selection|
      selection['right'] = get_by_id(selection['right_id'], @@side_tab)
      selection['left'] = get_by_id(selection['left_id'], @@side_tab)
    end
    selections
  end

  def get_by_id(id, relation)
    @db.exec(
      <<~CMD
        SELECT * FROM #{relation}
        WHERE id = #{id};
      CMD
    )
  end

  def build_state_selection(state_id)
    state = get_by_id(state_id, @@state_tab)[0]
    selection_id = optimal_selection_id(state['id'])
    selections = build_selections(selection_id)
    state['selections'] = selections
  end

  def optimal_selection_id(state_id)
    @db.exec(
      <<~CMD
        SELECT selection_id FROM #{@@optimal_tab}
        WHERE state_id = #{state_id};
      CMD
    )[0]['selection_id']
  end

  def get_resulting_states(selection_id)
    @db.exec(
      <<~CMD
        SELECT state_id FROM #{@@resulting_tab}
        WHERE optimal_selection_id = #{selection_id};
      CMD
    )
  end

  def build_resulting_states(selection_id)
    state_ids = get_resulting_states(selection_id)
    states = state_ids.map do |state_id|
      build_state_selection(state_id)
    end
  end

  def first_state
    {
      unknown: $DEFAULT_LENGTH,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    }
  end

end
