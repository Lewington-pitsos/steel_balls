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
    assert_equal 1, @lookup.selections.length
    assert_equal 2, @lookup.selections[0]['states'].length
    refute @lookup.selections[0]['states'][0]['selections']

    @lookup.build_all_selections(3)
    assert_equal 4, @lookup.selections.length
    refute @lookup.selections[0]['states'][0]['selections']
  end

  def teardown
    $WINNING_RATING = 37
    $DEFAULT_LENGTH = 8
    teardown_database
  end
end
