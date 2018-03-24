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
end
