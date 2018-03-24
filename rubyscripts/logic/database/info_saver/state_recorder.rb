# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './careful_saver'

class StateRecorder < CarefulSaver

  @@column_name = 'id'

  def initialize(name=@@database_name)
    super(name)
    @ids = []
    @relation_name = 'scored_states'
    @column_name = @@column_name
  end

  def record_states(all_states)
    all_states.each do |state|
      record_state_and_id(state)
    end
  end

  private

  attr_reader :ids

  def record_state_and_id(state)
    id = get_id(state[:state])
    if !id
      id = save(state[:state])
    end
    @ids << id
  end


end
