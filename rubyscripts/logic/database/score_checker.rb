# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './searcher'

class ScoreChecker < Searcher

  @@column_name = 'score'

  def initialize(name=@@database_name)
    super(name)
    @score = nil
  end

  def recorded_score(state)
    rubify(get_recorded_score(state), @@column_name)
  end

  private

  attr_reader :score

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
