# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.
require 'pry'
require_relative './careful_saver'

class StateRecorder < CarefulSaver

  attr_reader :ids

  @@column_name = 'id'

  def initialize(name=@@database_name)
    super(name)
    @ids = []
    @relation_name = 'scored_states'
    @column_name = @@column_name
  end

  def record_states(selection)
    @ids = []
    selection[:selection][:states].each do |state|
      @ids << record_state_and_id(state[:state])
    end
  end
end
