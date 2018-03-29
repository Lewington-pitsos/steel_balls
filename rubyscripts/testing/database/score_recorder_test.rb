require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/score_recorder'

class ScoreRecorderTest < DatabaseTester

  @@example_state = {
    state: {
      unknown: 4,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    score: 29
  }

  @@example_state2 = {
    state: {
      unknown: 2,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 2
    },
    score: 25
  }

  @@example_state3 = {
    state: {
      unknown: 2,
      possibly_heavier: 2,
      possibly_lighter: 0,
      normal: 2
    },
    score: 21
  }


  def get_score(id)
    @db.exec(
      <<~CMD
        SELECT score FROM scored_states
        WHERE id = #{id};
      CMD
    )[0]['score'].to_i
  end

  def get_fully_scored(id)
    @db.exec(
      <<~CMD
        SELECT fully_scored FROM scored_states
        WHERE id = #{id};
      CMD
    )[0]['fully_scored']
  end

  def setup
    setup_database_for_testing
    add_defaults(@@example_state[:state], @@example_state2[:state], @@example_state3[:state])
    @score_recorder = ScoreRecorder.new($DATABASE_NAME)
  end

  def test_updates_score_properly
    assert_equal 'f', get_fully_scored(1)
    assert_equal 999, get_score(1)
    @score_recorder.update_score(1, 4)
    assert_equal 4, get_score(1)
    assert_equal 'f', get_fully_scored(1)

    assert_equal 'f', get_fully_scored(2)
    @score_recorder.update_score(2, 0)
    assert_equal 0, get_score(2)
    assert_equal 'f', get_fully_scored(2)

    @score_recorder.update_score(3, 4)
    assert_equal 4, get_score(3)
  end

  def test_updates_score_and_full_score_properly
    assert_equal 'f', get_fully_scored(1)
    @score_recorder.update_full_score(1, 2, true)
    assert_equal 2, get_score(1)
    assert_equal 't', get_fully_scored(1)

    assert_equal 'f', get_fully_scored(3)
    @score_recorder.update_full_score(3, 9, false)
    assert_equal 9, get_score(3)
    assert_equal 'f', get_fully_scored(3)
  end

  def teardown
    teardown_database
  end
end
