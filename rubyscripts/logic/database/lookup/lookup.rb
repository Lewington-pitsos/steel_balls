require_relative '../archivist'

class Lookup < Archivist

  @@selection_tab = 'selections'
  @@side_tab = 'selection_sides'
  @@state_tab = 'scored_states'
  @@possible_tab = 'possible_selections'
  @@resulting_tab = 'resulting_states'

  @@selection_id_col = 'selection_id'
  @@state_id_col = 'state_id'

  attr_reader :tree, :selections

  def initialize(name=@@database_name, simplified=false)
    super(name)
    @tree = {}
    @simplified = simplified
    @depth = 999
    @selections = {}
  end

  def build_all_selections(id)
    @depth = 2
    @selections = build_state(id)['selections']
  end

  def build_tree
    @depth = 999
    first_id = state_id_by_values(first_state)
    @tree = build_state(first_id)
  end

  private

  def build_state(state_id)
    @depth -= 1
    state = get_by_id(state_id, @@state_tab)
    if @depth > 0
      selections = build_possible_selections(state_id)
      state['selections'] = selections
    end
    state
  end

  def build_possible_selections(state_id)
    full_selections = get_full_selections(state_id)
    selection_ids = ids_from(full_selections, @@selection_id_col)
    selection_ids.map do |selection_id|
      build_selection(selection_id)
    end
  end

  def get_full_selections(state_id)
    if @simplified
      single_possible_selection(state_id)
    else
      possible_selections(state_id)
    end
  end

  def build_selection(id)
    selection = get_by_id(id, @@selection_tab)
    selection['right'] = get_side(selection.delete('right_id'))
    selection['left'] = get_side(selection.delete('left_id'))
    selection['states'] = build_resulting_states(id)
    selection
  end

  def get_side(id_name)
    get_by_id(id_name, @@side_tab)
  end

  def build_resulting_states(selection_id)
    full_states = resulting_states(selection_id)
    state_ids = ids_from(full_states, @@state_id_col)
    state_ids.map do |state_id|
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

  def ids_from(rows, id_name)
    # gets passed in a PG:Result and the column name of the ids we want to extract
    # returns an array of ids
    ids = []
    rows.each do |row|
      ids << row[id_name]
    end
    ids
  end

  # ================ Query Methods ================

  def possible_selections(state_id)
    @db.exec(
      <<~CMD
        SELECT selection_id FROM #{@@possible_tab}
        WHERE state_id = #{state_id};
      CMD
    )
  end

  def single_possible_selection(state_id)
    @db.exec(
      <<~CMD
        SELECT selection_id FROM #{@@possible_tab}
        WHERE state_id = #{state_id}
        LIMIT 1;
      CMD
    )
  end

  def resulting_states(selection_id)
    @db.exec(
      <<~CMD
        SELECT state_id FROM #{@@resulting_tab}
        WHERE possible_selection_id = #{selection_id};
      CMD
    )
  end

  def get_by_id(id, relation)
    result = @db.exec(
      <<~CMD
        SELECT * FROM #{relation}
        WHERE id = #{id};
      CMD
    )[0]

    result.delete('id')
    result
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
