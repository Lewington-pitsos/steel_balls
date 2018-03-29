require_relative './archivist'
require_relative './save_helper'

class ScoreRecorder < Archivist

  @@relation_name = 'scored_states'

  def initialize(name=@@database_name)
    super(name)
    @relation_name = @@relation_name
  end

  def update_state_score(id, score, fully_scored)
    @db.exec(<<~CMD
        UPDATE scored_states
        SET score = #{score}, fully_scored = #{fully_scored}
        WHERE id = #{id};
      CMD
    )
  end

  def update_score(id, score, relation=@relation_name)
    binding.pry
    @db.exec(
      <<~COMMAND
        UPDATE #{relation}
        SET score = #{score}
        WHERE id = #{id};
      COMMAND
    )
  end

end
