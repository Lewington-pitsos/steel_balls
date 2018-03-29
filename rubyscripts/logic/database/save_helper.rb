module SaveHelper
  def save(state, relation=@relation_name)
    @db.exec(
      <<~COMMAND
          INSERT INTO #{relation} (
              unknown,
              possibly_lighter,
              possibly_heavier,
              normal
            )
          VALUES (
            #{state[:unknown]},
            #{state[:possibly_lighter]},
            #{state[:possibly_heavier]},
            #{state[:normal]}
          )
          RETURNING id;
      COMMAND
    )[0]['id'].to_i
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
