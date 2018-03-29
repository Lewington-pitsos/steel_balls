require_relative '../searcher'
require_relative '../save_helper'

class CarefulSaver < Searcher

  include SaveHelper

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

  def record_state_and_id(state, callback=method(:save))
    id = get_id(state)
    if !id
      id = callback.call(state)
    end
    id
  end
end
