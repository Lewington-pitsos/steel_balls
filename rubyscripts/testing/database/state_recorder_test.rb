require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require 'pg'
require_relative '../../logic/database/state_recorder'

class StateRecorderTest < Minitest::Test

  @@example_state = {
    state: {
      unknown: 4,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    state_score: 29,
    selections: []
  }

  @@example_state2 = {
    state: {
      unknown: 2,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 2
    },
    state_score: 25,
    selections: []
  }

  @@get_database_states = <<~CMD
    SELECT * FROM scored_states;
  CMD

  def setup
    @db = PG.connect({ dbname: $DATABASE_NAME, user: 'postgres' })
    @setup = Setup.new($DATABASE_NAME)
    @setup.suppress_warnings
    @setup.send(:clear_database)
    @setup.setup_if_needed
    @recorder = StateRecorder.new($DATABASE_NAME)
  end

  def test_records_single_state
    @recorder.send(:save_state, @@example_state)
    row = @db.exec(@@get_database_states)[0]

    @@example_state[:state].each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end
    assert_equal @@example_state[:state_score], row['score'].to_i
    assert_raises 'Error' do
      @db.exec(@@get_database_states)[1]
    end

    @recorder.send(:save_state, @@example_state2)
    row = @db.exec(@@get_database_states)[1]
    @@example_state2[:state].each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end
    assert_equal @@example_state2[:state_score], row['score'].to_i
  end

  def teardown
    @setup.send(:clear_database)
    @setup.close()
  end
end
