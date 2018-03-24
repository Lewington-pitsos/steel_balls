require_relative './archivist'

class Lookup < Archivist

  @@selection_tab = 'selections'
  @@side_tab = 'selection_sides'
  @@state_tab = 'scored_states'
  @@optimal_tab = 'optimal_selections'
  @@resulting_tab = 'resulting_states'

  @@selection_id_col = 'selection_id'
  @@state_id_col = 'state_id'

  attr_accessor :tree

  def initialize(name=@@database_name)
    super(name)
    @tree = {}
  end

  def build_tree
    first_id = state_id_by_values(first_state)
    @tree = build_state(first_id)
  end

  private

  def build_state(state_id)
    state = get_by_id(state_id, @@state_tab)
    selection_ids = get_ids_by_id(state_id, optimal_selection_id, @@selection_id_col)
    selections = selection_ids.map do |selection_id|
      build_selection(selection_id)
    end
    state['selections'] = selections
    state
  end

  def build_selection(id)
    selection = get_by_id(id, @@selection_tab)
    selection['right'] = get_by_id(selection['right_id'], @@side_tab)
    selection['left'] = get_by_id(selection['left_id'], @@side_tab)
    selection['states'] = build_resulting_states(id)
    selection
  end

  def build_resulting_states(selection_id)
    state_ids = get_ids_by_id(selection_id, resulting_states, @@state_id_col)
    states = state_ids.map do |state_id|
      build_state(state_id)
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

  def get_ids_by_id(id, callback, id_name)
    # gets passed in a single id, a callback function (which should be mostly a query) and the column name of the ids we want to extract
    # returns an array of ids
    rows = callback(id)
    ids = []
    rows.each do |row|
      ids << row[id_name]
    end
    ids
  end


  # ================ Query Methods ================

  def optimal_selection_ids(state_id)
    @db.exec(
      <<~CMD
        SELECT selection_id FROM #{@@optimal_tab}
        WHERE state_id = #{state_id};
      CMD
    ).
  end

  def resulting_states(selection_id)
    @db.exec(
      <<~CMD
        SELECT state_id FROM #{@@resulting_tab}
        WHERE optimal_selection_id = #{selection_id};
      CMD
    )
  end

  def get_by_id(id, relation)
    @db.exec(
      <<~CMD
        SELECT * FROM #{relation}
        WHERE id = #{id};
      CMD
    )[0]
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
