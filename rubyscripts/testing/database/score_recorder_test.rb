require "minitest/autorun"
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

  def setup
    setup_database_for_testing

    @state_recorder = StateRecorder.new($DATABASE_NAME)
    @state_recorder.send(:save_state, @@example_state)
    @state_recorder.send(:save_state, @@example_state2)
    @state_recorder.send(:save_state, @@example_state3)
    @score_recorder = ScoreRecorder.new($DATABASE_NAME)
  end

  def test_returns_correct_ids
    assert_equal 1, @score_recorder.record_score(@@example_state)
    assert_equal 3, @score_recorder.record_score(@@example_state3)
    assert_equal 2, @score_recorder.record_score(@@example_state2)
  end

  def test_stores_correct_scores
    @score_recorder.record_score(@@example_state)
    @score_recorder.record_score(@@example_state2)
    @score_recorder.record_score(@@example_state3)
    assert_equal 29, get_score(1)
    assert_equal 25, get_score(2)
    assert_equal 21, get_score(3)
  end

  def teardown
    teardown_database
  end
end
