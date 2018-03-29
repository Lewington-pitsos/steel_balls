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
    @possible_selection_id = 0
  end

  def save_selection_data(scored_selection, state_id, resulting_state_ids)
    record_selection(scored_selection[:selection])
    record_prev_state(state_id)
    record_resulting_states(resulting_state_ids)
  end

  private

  attr_writer :left_id, :right_id, :selection_id

  def record_selection(selection)
    record_sides(selection)
    @selection_id = save_selection
  end

  def record_sides(selection)
    # saves both the sides (iff they haven't already been covered) finds the id's of both sides, and saves the selection using those ids
    @left_id = record_state_and_id(selection[:left])
    @right_id = record_state_and_id(selection[:right])
  end

  def save_selection
    @db.exec(
      <<~COMMAND
        INSERT INTO selections (left_id, right_id)
        VALUES (#{@left_id}, #{@right_id})
        RETURNING id;
      COMMAND
    )[0]['id'].to_i
  end

  def record_prev_state(state_id)
    @possible_selection_id = @db.exec(
      <<~COMMAND
        INSERT INTO possible_selections (state_id, selection_id)
        VALUES ( #{state_id}, #{@selection_id})
        RETURNING id;
      COMMAND
    )[0]['id'].to_i
  end

  def record_resulting_states(state_ids)
    state_ids.each do |state_id|
      save_resulting_state(state_id)
    end
  end

  def save_resulting_state(state_id)
    @db.exec(
      <<~COMMAND
        INSERT INTO resulting_states ( possible_selection_id, state_id)
        VALUES ( #{@possible_selection_id}, #{state_id} )
      COMMAND
    )
  end
end
