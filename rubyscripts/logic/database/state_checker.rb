# checks whether or not the current state has been recorded yet
# => if not it just returns nil
# => if so, we return a hash containing the state id, it's score and whether it has been fully scored'

# { 'score' => 2, 'fully_scored' => false, 'id' => 3 }

require_relative './searcher'

class StateChecker < Searcher

  @@column_name = 'score'

  def initialize(name=@@database_name)
    super(name)
    @score = nil
  end

  def recorded_score(state)
    rubify(get_recorded_score(state), 'score', 'id', 'fully_scored')
  end

  private

  attr_reader :score

  def get_recorded_score(state)
    @score = @db.exec(
      <<~CMD
        SELECT score, id, fully_scored FROM scored_states
          WHERE unknown = #{state[:unknown]} AND
            possibly_lighter = #{state[:possibly_lighter]} AND
            possibly_heavier = #{state[:possibly_heavier]} AND
            normal = #{state[:normal]};
      CMD
    )
  end
end
