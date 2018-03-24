# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'

class ScoreChecker < Archivist

  @@column_name = 'score'

  def initialize(name=@@database_name)
    super(name)
    @score = nil
  end

  def recorded_score(state)
    rubify(get_recorded_score(state))
  end

  private

  attr_reader :score

  def rubify(pg_result)
    # returns the actual number value represented within the pg result, or nil if the pg result came up with no matches
    if pg_result.ntuples == 1
      pg_result[0][@@column_name].to_i
    else
      nil
    end
  end

  def get_recorded_score(state)
    @score = @db.exec(
      <<~CMD
        SELECT score FROM scored_states
          WHERE unknown = #{state[:unknown]} AND
            possibly_lighter = #{state[:possibly_lighter]} AND
            possibly_heavier = #{state[:possibly_heavier]} AND
            normal = #{state[:normal]} AND
            score IS NOT NULL;
      CMD
    )
  end
end
