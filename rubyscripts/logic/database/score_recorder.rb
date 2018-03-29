require_relative './archivist'
require_relative './save_helper'

class ScoreRecorder < Archivist

  include SaveHelper

  @@relation_name = 'scored_states'

  def initialize(name=@@database_name)
    super(name)
    @relation_name = @@relation_name
  end

  def update_score(id, score, relation=@relation_name)
    @db.exec(
      <<~COMMAND
        UPDATE #{relation}
        SET score = #{score}
        WHERE id = #{id};
      COMMAND
    )
  end
end
