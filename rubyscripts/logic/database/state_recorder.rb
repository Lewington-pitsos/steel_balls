# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './searcher'

class StateRecorder < Searcher

  @@column_name = 'id'

  def initialize(name=@@database_name)
    super(name)
    @ids = []
  end

  def record_states(all_states)
    all_states.each do |state|
      record_state_and_id(state)
    end
  end

  private

  attr_reader :ids

  def record_state_and_id(state)
    id = get_state_id(state)
    if !id
      id = save_state(state)
    end
    @ids << id
  end

  def get_state_id(state)
    result = @db.exec(
      <<~COMMAND
          SELECT id FROM scored_states
            WHERE unknown = #{state[:state][:unknown]} AND
              possibly_lighter = #{state[:state][:possibly_lighter]} AND
              possibly_heavier = #{state[:state][:possibly_heavier]} AND
              normal = #{state[:state][:normal]};
      COMMAND
    )
    rubify(result, @@column_name)
  end

  def save_state(state)
    @db.exec(
      <<~COMMAND
          INSERT INTO scored_states (
              unknown,
              possibly_lighter,
              possibly_heavier,
              normal
            )
          VALUES (
            #{state[:state][:unknown]},
            #{state[:state][:possibly_lighter]},
            #{state[:state][:possibly_heavier]},
            #{state[:state][:normal]}
          )
          RETURNING id;
      COMMAND
    )[0]['id'].to_i
  end
end
