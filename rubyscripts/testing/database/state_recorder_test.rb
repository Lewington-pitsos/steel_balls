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
    rating: 29,
  }

  @@example_state2 = {
    state: {
      unknown: 2,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 2
    },
    rating: 25,
  }

  @@example_state3 = {
    state: {
      unknown: 2,
      possibly_heavier: 2,
      possibly_lighter: 0,
      normal: 2
    },
    rating: 25,
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
    @recorder = StateRecorder.new($DATABASE_NAME)
  end

  def test_records_single_state
    @recorder.send(:save_state, @@example_state)
    row = @db.exec(@@get_database_states)[0]

    @@example_state[:state].each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end

    assert_raises 'Error' do
      @db.exec(@@get_database_states)[1]
    end

    @recorder.send(:save_state, @@example_state2)
    row = @db.exec(@@get_database_states)[1]
    @@example_state2[:state].each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end
  end

  def test_returns_last_state_id
    id = @recorder.send(:save_state, @@example_state)
    assert_equal 1, id
    id = @recorder.send(:save_state, @@example_state2)
    assert_equal 2, id
    id = @recorder.send(:save_state, @@example_state3)
    assert_equal 3, id
  end

  def test_retrives_correct_id_from_recorded_states
    @recorder.send(:save_state, @@example_state)
    @recorder.send(:save_state, @@example_state2)
    @recorder.send(:save_state, @@example_state3)

    id = @recorder.send(:get_state_id, @@example_state)
    assert_equal 1, id
    id = @recorder.send(:get_state_id, @@example_state2)
    assert_equal 2, id
    id = @recorder.send(:get_state_id, @@example_state3)
    assert_equal 3, id
  end

  def test_returns_nil_for_non_recorded_states
    refute @recorder.send(:get_state_id, @@example_state)
    refute @recorder.send(:get_state_id, @@example_state2)
  end

  def test_saves_ids_of_recorded_or_found_states
    @recorder.send(:save_state, @@example_state)
    @recorder.send(:record_state_and_id, @@example_state2)
    @recorder.send(:record_state_and_id, @@example_state)
    @recorder.send(:record_state_and_id, @@example_state3)

    [2, 1, 3].each_with_index do |num, index|
      assert_equal num, @recorder.send(:ids)[index]
    end
  end

  def test_records_an_array_of_states
    @recorder.record_states(@@state_array)
    [1, 2, 3].each_with_index do |num, index|
      assert_equal num, @recorder.send(:ids)[index]
    end
  end

  def teardown
    @setup.send(:clear_database)
    @setup.close()
  end
end
