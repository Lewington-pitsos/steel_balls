# gets passed in the lowest scored selection, the id fo the previous state and al the ids of the resulting states

# saves the selection to the selections table
# saves the selection id and previous state id to the best_selections table
# saves the best_selection id to the selection_results table for each of the resulting states

require_relative './archivist'

class SelectionRecorder < Archivist

  def initialize(name=@@database_name)
    super(name)
  end

  def save_selections(scored_selections)
    scored_selections.each do |selection|
      record_sides(selection)
    end
  end

  private

  def record_sides(selection)
    # saves both the sides (iff they haven't already been covered) finds the id's of both sides, and saves the selection using those ids
    left_side_id = save_and_get_id(selection[:left])
    right_side_id = save_and_get_id(selection[:right])
    save_selection(left_side_id, right_side_id, selection[:score])
  end

  def save_and_get_id(side)
    save_side(side)
    get_side_id(side)
  end

  def save_side(side)
    @db.exec(
      <<~COMMAND
          IF EXISTS ( SELECT 1
            FROM selection_sides
            WHERE unknown = #{side[:unknown]} AND
              possibly_lighter = #{side[:possibly_lighter]} AND
              possibly_heavier = #{side[:possibly_heavier]} AND
              normal = #{side[:normal]}
            )
          THEN
          INSERT INTO selection_sides (
              unknown,
              possibly_lighter,
              possibly_heavier,
              normal
            )
          VALUES (
            #{side[:unknown]},
            #{side[:possibly_lighter]},
            #{side[:possibly_heavier]},
            #{side[:normal]}
          )
        END IF;
      COMMAND
    )
  end

  def get_side_id(side)
    @db.exec(
      <<~COMMAND
        SELECT id FROM selection_sides
        WHERE unknown = #{side[:unknown]} AND
          possibly_lighter = #{side[:possibly_lighter]} AND
          possibly_heavier = #{side[:possibly_heavier]} AND
          normal = #{side[:normal]};
      COMMAND
    ).values[0]
  end
end
