# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'

class ScoreChceker < Archivist

  def initialize(name=false)
    super(name)
  end

  def recorded_score(state)
    score = @db.exec(
      <<~CMD
        SELECT score FROM scored_states
          WHERE unknown = #{side[:unknown]} AND
            possibly_lighter = #{side[:possibly_lighter]} AND
            possibly_heavier = #{side[:possibly_heavier]} AND
            normal = #{side[:normal]}
      CMD
    ).values
  end
end
