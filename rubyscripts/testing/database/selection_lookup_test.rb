require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/lookup/selection_lookup'
require './rubyscripts/logic/state_manager'


class SelectionLookupTest < DatabaseTester

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

  @@hash = {
    'id' => '3',
    'fully_scored' => 't',
    'unknown' => '0'
  }

  def setup
    setup_database_for_testing
    add_defaults(@@starting_rated_state[:state])
    $WINNING_RATING = 12
    $DEFAULT_LENGTH = 3
    @manager = StateManager.new(@@starting_rated_state)
    @manager.score()

    @lookup = SelectionLookup.new($DATABASE_NAME)
  end

  def test_returns_single_selection_build
    @lookup.build_all_selections(1)
    assert_equal 1, @lookup.all_selections.length
    assert_equal 2, @lookup.all_selections[0][:selection][:states].length
    assert_equal 9, @lookup.all_selections[0][:rating]
    refute @lookup.all_selections[0][:selection][:states][0]['selections']


    @lookup.build_all_selections(3)
    assert_equal 4, @lookup.all_selections.length
    refute @lookup.all_selections[0][:selection][:states][0]['selections']
    assert_equal 12, @lookup.all_selections[-1][:rating]
  end

  def test_state_hashes_properly_arranged
    state = @lookup.send(:build_state, 1)
    assert_equal 3, state[:state][:unknown]
    assert_equal 0, state[:rating]

    state = @lookup.send(:build_state, 2)
    assert_equal 1, state[:state][:unknown]
    assert_equal 10, state[:rating]
  end

  def test_converts_hashes
    hash = @lookup.send(:symbolized, @@hash)
    assert hash[:unknown]
    assert hash[:id]
    assert hash[:fully_scored]
  end

  def test_limits_selections_gathered
    @lookup.send(:state_id=, 3)
    selections = @lookup.send(:build_possible_selections, 3)
    assert_equal 4, selections.length

    @lookup.send(:state_id=, 3)
    selections = @lookup.send(:build_possible_selections, 3, 1)
    assert_equal 2, selections.length
  end

  def teardown
    $WINNING_RATING = 37
    $DEFAULT_LENGTH = 8
    teardown_database
  end
end
