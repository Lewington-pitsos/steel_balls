require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/lookup'
require './rubyscripts/logic/state_manager'

class ScoreCheckerTest < DatabaseTester

  @@starting_state = {
    state: {
      unknown: 3,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }


  def setup
    setup_database_for_testing
    add_defaults(@@starting_state[:state])
    $WINNING_RATING = 12
    $DEFAULT_LENGTH = 3
    @manager = StateManager.new(@@starting_state)
    @manager.score()

    @lookup = Lookup.new($DATABASE_NAME)
  end

  def test_retrival_by_id_works

  end

  def teardown
    teardown_database
  end
end
