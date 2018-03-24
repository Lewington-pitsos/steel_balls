# saves the passed in score to the row for the passed in state and returns the id of that row.

# NOTE: there MUST be a row for the passed in state because we record all states (without scores) before attempting to find scores for any of them (Including the very first state)

require_relative './searcher'

class ScoreRecorder < Archivist

  def initialize(name=@@database_name)
    super(name)
  end

  def record_score(scored_state)
    save_score(scored_state[:state], scored_state[:score])
  end

  private

  def save_score(state, score)
    @db.exec(
      <<~COMMAND
        UPDATE scored_states
        SET score = #{score}
        WHERE unknown = #{state[:unknown]} AND
          possibly_lighter = #{state[:possibly_lighter]} AND
          possibly_heavier = #{state[:possibly_heavier]} AND
          normal = #{state[:normal]}
        RETURNING id;
      COMMAND
    )[0]['id'].to_i
  end
end
