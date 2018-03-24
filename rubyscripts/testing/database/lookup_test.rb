require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/lookup'
require './rubyscripts/logic/state_manager'

class ScoreCheckerTest < DatabaseTester

  @@starting_rated_state = {
    state: {
      unknown: 3,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }

  @@other_state = {
    unknown: 1,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 2
  }

  def setup
    setup_database_for_testing
    add_defaults(@@starting_rated_state[:state])
    $WINNING_RATING = 12
    $DEFAULT_LENGTH = 3
    @manager = StateManager.new(@@starting_rated_state)
    @manager.score()

    @lookup = Lookup.new($DATABASE_NAME)
  end

  def test_retrival_by_id_works
    assert_equal '1', @lookup.send(:get_by_id, '1', 'scored_states')['id']
    assert_equal '2', @lookup.send(:get_by_id, '1', 'scored_states')['score']
    assert_equal '1', @lookup.send(:get_by_id, '5', 'scored_states')['score']
    assert_raises 'Error' do
      @lookup.get_by_id('6', 'scored_states')
    end

    assert_equal '1', @lookup.send(:get_by_id, '1', 'selections')['left_id']
    assert_equal '2', @lookup.send(:get_by_id, '1', 'selections')['right_id']
    assert_equal '1', @lookup.send(:get_by_id, '4', 'selections')['left_id']
    assert_equal '4', @lookup.send(:get_by_id, '4', 'selections')['right_id']
    assert_raises 'Error' do
      @lookup.get_by_id('8', 'selections')
    end

    assert_equal '0', @lookup.send(:get_by_id, '1', 'selection_sides')['unknown']
    assert_equal '1', @lookup.send(:get_by_id, '2', 'selection_sides')['unknown']
    assert_equal '1', @lookup.send(:get_by_id, '1', 'selection_sides')['normal']
  end

  def test_creates_proper_first_state
    assert_equal $DEFAULT_LENGTH, @lookup.send(:first_state)[:unknown]

    $DEFAULT_LENGTH = 9
    assert_equal $DEFAULT_LENGTH, @lookup.send(:first_state)[:unknown]
  end

  def test_gets_correct_state_via_state_values
    assert_equal '1', @lookup.send(:state_id_by_values, @@starting_rated_state[:state])
    assert_equal '2', @lookup.send(:state_id_by_values, @@other_state)
  end

  def test_returns_all_optimal_selections
    selections = @lookup.send(:optimal_selection_ids, '1')
    assert_equal 1, selections.ntuples
    selections.each do |sel|
      assert_equal '7', sel['selection_id']
    end

    selections = @lookup.send(:optimal_selection_ids, '5')
    selections.each_with_index do |sel, index|
      assert_equal (index + 3).to_s, sel['selection_id']
    end
  end

  def test_returns_correct_resulting_states
    selections = @lookup.send(:resulting_states, '1')
    assert_equal 2, selections.ntuples
    selections.each_with_index do |sel, index|
      assert_equal (index + 3).to_s, sel['state_id']
    end

  end

  def teardown
    teardown_database
  end
end
