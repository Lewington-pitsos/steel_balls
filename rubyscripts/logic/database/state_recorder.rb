# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'
require_relative './selection_recorder'

class StateRecorder < Archivist

  def initialize(name=@@database_name)
    super(name)
    @ids = []
  end

  def record_state(all_states)
    all_states.each do |state|
      record_state_and_id(state)
    end
  end

  private

  def record_state_and_id(state)
    id = get_state_id(state)
    if !id
      save_state(state)
      id = most_recent_id()
    end
    @ids << id
  end

  def get_state_id(state)
    @db.exec(
      <<~COMMAND
          SELECT id FROM scored_states
            WHERE unknown = #{state[:unknown]} AND
              possibly_lighter = #{state[:possibly_lighter]} AND
              possibly_heavier = #{state[:possibly_heavier]} AND
              normal = #{state[:normal]};
          );
      COMMAND
    )
  end

  def save_state(state)
    @db.exec(
      <<~COMMAND
          INSERT INTO scored_states (
              unknown,
              possibly_lighter,
              possibly_heavier,
              normal,
            )
          VALUES (
            #{state[:state][:unknown]},
            #{state[:state][:possibly_lighter]},
            #{state[:state][:possibly_heavier]},
            #{state[:state][:normal]}
          );
      COMMAND
    )
  end

  def most_recent_id
    @db.exec(
      <<~COMMAND
          IDENT_CURRENT('scored_states');
      COMMAND
    )
  end
end
