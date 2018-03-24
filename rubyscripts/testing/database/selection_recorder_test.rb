require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/selection_recorder'
require './rubyscripts/logic/database/state_recorder'

class SelectionRecorderTest < DatabaseTester

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
      possibly_heavier: 3,
      possibly_lighter: 0,
      normal: 2
    },
    rating: 25,
  }

  @@example_side = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@example_side2 = {
    unknown: 4,
    possibly_heavier: 2,
    possibly_lighter: 0,
    normal: 0
  }

  @@example_side3 = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 1
  }

  @@example_selection = {
    left: @@example_side,
    right: @@example_side2
  }

  def setup
    setup_database_for_testing
    @state_recorder = StateRecorder.new()
    @recorder = SelectionRecorder.new($DATABASE_NAME)
  end

  def test_records_single_side
    @recorder.send(:save, @@example_side)
    row = get_all('selection_sides')[0]

    @@example_side.each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end

    assert_raises 'Error' do
      get_all('selection_sides')[1]
    end

    @recorder.send(:save, @@example_side2)
    row = get_all('selection_sides')[1]
    @@example_side2.each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end
  end

  def test_returns_last_side_id
    id = @recorder.send(:save, @@example_side)
    assert_equal 1, id
    id = @recorder.send(:save, @@example_side2)
    assert_equal 2, id
    id = @recorder.send(:save, @@example_side3)
    assert_equal 3, id
  end

  def test_retrives_correct_id_from_recorded_sides
    @recorder.send(:save, @@example_side)
    @recorder.send(:save, @@example_side2)
    @recorder.send(:save, @@example_side3)

    id = @recorder.send(:get_id, @@example_side)
    assert_equal 1, id
    id = @recorder.send(:get_id, @@example_side2)
    assert_equal 2, id
    id = @recorder.send(:get_id, @@example_side3)
    assert_equal 3, id
  end

  def test_returns_nil_for_non_recorded_sides
    refute @recorder.send(:get_id, @@example_side)
    refute @recorder.send(:get_id, @@example_side2)
  end

  def test_saves_selection_object_properly
    @recorder.send(:save, @@example_side)
    @recorder.send(:save, @@example_side2)
    @recorder.send(:save, @@example_side3)
    @recorder.send(:left_id=, 1)
    @recorder.send(:right_id=, 2)

    assert_raises 'Error' do
      get_all('selections')[0]
    end

    @recorder.send(:save_selection)

    assert_equal '1', get_all('selections')[0]['id']
    assert_equal '1', get_all('selections')[0]['left_id']
    assert_equal '2', get_all('selections')[0]['right_id']

    assert_raises 'Error' do
      get_all('selections')[1]
    end

    @recorder.send(:left_id=, 3)
    @recorder.send(:save_selection)
    assert_equal '2', get_all('selections')[1]['id']
    assert_equal '3', get_all('selections')[1]['left_id']
    assert_equal '2', get_all('selections')[1]['right_id']
  end

  def test_saves_proper_seletion_id
    @recorder.send(:save, @@example_side)
    @recorder.send(:save, @@example_side2)
    @recorder.send(:save, @@example_side3)
    @recorder.send(:left_id=, 1)
    @recorder.send(:right_id=, 2)
    id = @recorder.send(:save_selection)

    assert_equal 1, id

    @recorder.send(:left_id=, 3)
    id = @recorder.send(:save_selection)

    assert_equal 2, id
  end

  def test_associates_selection_with_previous_state
    @state_recorder.send(:save, @@example_state[:state])
    @state_recorder.send(:save, @@example_state2[:state])
    @recorder.send(:save, @@example_side)
    @recorder.send(:save, @@example_side2)
    @recorder.send(:save, @@example_side3)
    @recorder.send(:left_id=, 1)
    @recorder.send(:right_id=, 2)
    selection_id = @recorder.send(:save_selection)
    @recorder.send(:selection_id=, selection_id)

    assert_raises 'Error' do
      get_all('optimal_selections')[0]
    end

    id = @recorder.send(:record_prev_state, 2)

    assert_equal 1, id

    assert_equal 1, get_all('optimal_selections')[0]['id'].to_i
    assert_equal id, get_all('optimal_selections')[0]['selection_id'].to_i
    assert_equal 2, get_all('optimal_selections')[0]['state_id'].to_i
  end

  def test_associates_optimal_state_with_next_states
    @state_recorder.send(:save, @@example_state[:state])
    @state_recorder.send(:save, @@example_state2[:state])
    @state_recorder.send(:save, @@example_state3[:state])

    @recorder.send(:save, @@example_side)
    @recorder.send(:save, @@example_side2)
    @recorder.send(:save, @@example_side3)
    @recorder.send(:left_id=, 1)
    @recorder.send(:right_id=, 2)
    selection_id = @recorder.send(:save_selection)
    @recorder.send(:selection_id=, selection_id)
    id = @recorder.send(:record_prev_state, 2)

    assert_raises 'Error' do
      get_all('resulting_states')[0]
    end

    @recorder.send(:record_resulting_states, [1, 3])

    assert_equal 2, get_all('resulting_states').ntuples
    assert_equal 1, get_all('resulting_states')[0]['state_id'].to_i
    assert_equal 3, get_all('resulting_states')[1]['state_id'].to_i
    assert_equal id, get_all('resulting_states')[0]['optimal_selection_id'].to_i
    assert_equal id, get_all('resulting_states')[1]['optimal_selection_id'].to_i
  end


  def teardown
    teardown_database
  end
end
