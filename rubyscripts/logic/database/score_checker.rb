# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'

class ScoreChecker < Archivist

  def initialize(name=false)
    super(name)
    @score = nil
  end

  def recorded_score(state)
    get_recorded_score(state)
    if @score.ntuples == 1
      @score[0]['score'].to_i
    else
      nil
    end
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
            normal = #{state[:normal]}
      CMD
    )
  end
end
