# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'
require_relative './selection_recorder'

class StateRecorder < Archivist

  def initialize(name=false)
    super(name)
    @selection_recorder = SelectionRecorder.new()
  end

  def record_state(scored_state)
    selections = scored_state[:selections]
    @selection_recorder.save_selections(selections)
    record_state(state)
  end

  private

  def record_state(state)
    @db.exec(
      <<~COMMAND
          INSERT INTO scored_states (
              unknown,
              possibly_lighter,
              possibly_heavier,
              normal,
              score
            )
          VALUES (
            #{state[:state][:unknown]},
            #{state[:state][:possibly_lighter]},
            #{state[:state][:possibly_heavier]},
            #{state[:state][:normal]},
            #{state[:score]}
          )
        END IF;
      COMMAND
    )
  end
end
