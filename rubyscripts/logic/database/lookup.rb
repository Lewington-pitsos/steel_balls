require_relative './archivist'

class Lookup < Archivist

  @@selection_tab = 'selections'
  @@side_tab = 'selection_sides'
  @@state_tab = 'scored_states'
  @@possible_tab = 'possible_selections'
  @@resulting_tab = 'resulting_states'

  @@selection_id_col = 'selection_id'
  @@state_id_col = 'state_id'

  def initialize(name=@@database_name, simplified=false)
    super(name)
  end

  private

  def build_possible_selections(state_id)
    full_selections = get_full_selections(state_id)
    selection_ids = ids_from(full_selections, @@selection_id_col)
    selection_ids.map do |selection_id|
      build_selection(selection_id)
    end
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
end
