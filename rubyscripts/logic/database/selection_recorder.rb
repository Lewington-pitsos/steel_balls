# gets passed in the lowest scored selection, the id fo the previous state and al the ids of the resulting states

# saves the selection to the selections table
# saves the selection id and previous state id to the best_selections table
# saves the best_selection id to the selection_results table for each of the resulting states

require_relative './careful_saver'

class SelectionRecorder < CarefulSaver

  @@relation_name = 'selection_sides'
  @@column_name = 'id'

  def initialize(name=@@database_name)
    super(name)
    @relation_name = @@relation_name
    @column_name = @@column_name
  end

  def save_selections(scored_selections, state_id, resulting_states)
    scored_selections.each do |selection|
      record_sides(selection)
    end
  end

  private

  def record_sides(selection)
    # saves both the sides (iff they haven't already been covered) finds the id's of both sides, and saves the selection using those ids
    left_side_id = identify_side(selection[:left])
    right_side_id = identify_side(selection[:right])
    save_selection(left_side_id, right_side_id, selection[:score])
  end

  def identify_side(side)
    id = get_id(side)
    if !id
      id = save(side)
    end
    id
  end
end
