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
    @left_id = 0
    @right_id = 0
    @selection_id = 0
  end

  def save_selections(scored_selection, state_id, resulting_states)
    record_selection(selection)
    save_selection()
  end

  private

  attr_writer :left_id, :right_id

  def record_selection
    record_sides
    @selection_id = save_selection
  end

  def record_sides(selection)
    # saves both the sides (iff they haven't already been covered) finds the id's of both sides, and saves the selection using those ids
    @left_id = identify_side(selection[:left])
    @right_id = identify_side(selection[:right])
  end

  def identify_side(side)
    id = get_id(side)
    if !id
      id = save(side)
    end
    id
  end

  def save_selection
    @db.exec(
      <<~COMMAND
        INSERT INTO selections (left_id, right_id)
        VALUES (#{@left_id}, #{@right_id})
        RETURNING id;
      COMMAND
    )
  end
end
