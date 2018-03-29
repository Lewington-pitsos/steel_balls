# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.
require 'pry'
require_relative './careful_saver'

class StateRecorder < CarefulSaver

  attr_reader :ids

  @@column_name = 'id'
  @@relation_name = 'scored_states'

  def initialize(name=@@database_name)
    super(name)
    @ids = []
    @relation_name = @@relation_name
    @column_name = @@column_name
  end

  def record_states(selection)
    @ids = []
    selection[:selection][:states].each do |state|
      @rating = state[:rating]
      id = record_state_and_id(state[:state], method(:save_state_and_rating))
      if state[:rating] >= ($WINNING_RATING || 37)
        update_full_score(id, 0, true)
      end
      @ids << id
    end
  end

  def save_state_and_rating(state)
    @db.exec(
      <<~COMMAND
          INSERT INTO scored_states (
              unknown,
              possibly_lighter,
              possibly_heavier,
              normal,
              rating
            )
          VALUES (
            #{state[:unknown]},
            #{state[:possibly_lighter]},
            #{state[:possibly_heavier]},
            #{state[:normal]},
            #{@rating}
          )
          RETURNING id;
      COMMAND
    )[0]['id'].to_i
  end
end
