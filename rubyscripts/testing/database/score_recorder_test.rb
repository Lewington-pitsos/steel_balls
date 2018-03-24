require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require 'pg'
require_relative '../../logic/database/score_recorder'

class ScoreRecorderTest < Minitest::Test

  @@example_state = {
    state: {
      unknown: 4,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    score: 29,
  }

  @@example_state2 = {
    state: {
      unknown: 2,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 2
    },
    score: 25,
  }

  @@example_state3 = {
    state: {
      unknown: 2,
      possibly_heavier: 2,
      possibly_lighter: 0,
      normal: 2
    },
    score: 25,
  }

  @@get_database_states = <<~CMD
    SELECT * FROM scored_states;
  CMD

  @@state_array = [
    @@example_state,
    @@example_state2,
    @@example_state3
  ]

  def setup
    @db = PG.connect({ dbname: $DATABASE_NAME, user: 'postgres' })
    @setup = Setup.new($DATABASE_NAME)
    @setup.suppress_warnings
    @setup.send(:clear_database)
    @setup.setup_if_needed

    @state_recorder = StateRecorder.new($DATABASE_NAME)
    @state_recorder.send(:save_state, @@example_state)
    @score_recorder = ScoreRecorder.new($DATABASE_NAME)
  end

  def teardown
    @setup.send(:clear_database)
    @setup.close()
  end
end
