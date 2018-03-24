require_relative '../searcher'

class CarefulSaver < Searcher

  def initialize(name)
    super(name)
  end

  def get_id(state, relation=@relation_name)
    result = @db.exec(
      <<~COMMAND
          SELECT id FROM #{relation}
            WHERE unknown = #{state[:unknown]} AND
              possibly_lighter = #{state[:possibly_lighter]} AND
              possibly_heavier = #{state[:possibly_heavier]} AND
              normal = #{state[:normal]};
      COMMAND
    )
    rubify(result, @column_name)
  end

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
