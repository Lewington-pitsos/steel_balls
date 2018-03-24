require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/info_saver/state_recorder'

class StateRecorderTest < DatabaseTester

  @@example_state = {
    state: {
      unknown: 4,
      possibly_heavier: 1,
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

  @@example_selection = {
    left: {},
    right: {},
    states: @@state_array
  }

  @@example_proper_selection = {
      selection:{
      left: {},
      right: {},
      states: @@state_array
    }
  }

  def setup
    setup_database_for_testing
    @recorder = StateRecorder.new($DATABASE_NAME)
  end

  def test_records_single_state
    @recorder.send(:save, @@example_state[:state])
    row = @db.exec(@@get_database_states)[0]

    @@example_state[:state].each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end

    assert_raises 'Error' do
      @db.exec(@@get_database_states)[1]
    end

    @recorder.send(:save, @@example_state2[:state])
    row = @db.exec(@@get_database_states)[1]
    @@example_state2[:state].each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end
  end

  def test_returns_last_state_id
    id = @recorder.send(:save, @@example_state[:state])
    assert_equal 1, id
    id = @recorder.send(:save, @@example_state2[:state])
    assert_equal 2, id
    id = @recorder.send(:save, @@example_state3[:state])
    assert_equal 3, id
  end

  def test_retrives_correct_id_from_recorded_states
    @recorder.send(:save, @@example_state[:state])
    @recorder.send(:save, @@example_state2[:state])
    @recorder.send(:save, @@example_state3[:state])

    id = @recorder.send(:get_id, @@example_state[:state])
    assert_equal 1, id
    id = @recorder.send(:get_id, @@example_state2[:state])
    assert_equal 2, id
    id = @recorder.send(:get_id, @@example_state3[:state])
    assert_equal 3, id
  end

  def test_returns_nil_for_non_recorded_states
    refute @recorder.send(:get_id, @@example_state[:state])
    refute @recorder.send(:get_id, @@example_state2[:state])
  end

  def test_saves_ids_of_recorded_or_found_states
    @recorder.send(:save, @@example_state[:state])

    ids = []
    ids << @recorder.send(:record_state_and_id, @@example_state2[:state])
    ids << @recorder.send(:record_state_and_id, @@example_state[:state])
    ids << @recorder.send(:record_state_and_id, @@example_state3[:state])

    [2, 1, 3].each_with_index do |num, index|
      assert_equal num, ids[index]
    end
  end

  def test_records_an_array_of_states
    @recorder.record_states(@@example_proper_selection)
    [1, 2, 3].each_with_index do |num, index|
      assert_equal num, @recorder.send(:ids)[index]
    end
  end

  def teardown
    teardown_database
  end
end
