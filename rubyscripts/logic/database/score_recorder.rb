require_relative './archivist'
require_relative './save_helper'

class ScoreRecorder < Archivist

  include SaveHelper

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
end
