require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require 'pg'
require_relative '../../logic/database/setup'

class SetupTest < Minitest::Test


  @@weird_db_name = 'xesgytpbt_saldutvet'

  @@state12 = {
    unknown: 12,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@state8 = {
    unknown: 8,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }


  @@state2 = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@marked_state = {
    unknown: 2,
    possibly_heavier: 2,
    possibly_lighter: 2,
    normal: 2
  }


  def setup
    @setup = Setup.new()
    @setup.suppress_warnings
    @setup.send(:clear_database)
  end

  def test_identifies_empty_database
    assert @setup.send(:tables_missing)
  end

  def test_identifies_set_up_database
    @setup.send(:setup_tables)
    refute @setup.send(:tables_missing)
  end

  def test_sets_up_empty_database
    @setup.setup_if_needed
    refute @setup.send(:tables_missing)
  end

  def test_drops_set_up_database
    assert @setup.send(:setup_tables)
    refute @setup.send(:tables_missing)
    @setup.send(:clear_database)
    assert @setup.send(:tables_missing)
  end

  def test_populates_default_states
    assert @setup.send(:setup_tables)
    @setup.add_default_states(@@state12, @@state8, @@state2, @@marked_state)
    states = PG.connect({ dbname: $DATABASE_NAME, user: 'postgres' }).exec(
      'SELECT * FROM scored_states'
    )

    assert_equal '12', states[0]['unknown']
    assert_equal '0', states[0]['normal']
    assert_equal '0', states[0]['possibly_heavier']
    assert_equal '0', states[0]['possibly_lighter']
    assert_equal '8', states[1]['unknown']
    assert_equal '2', states[3]['unknown']
    assert_equal '2', states[3]['normal']
    assert_equal '2', states[3]['possibly_heavier']
    assert_equal '2', states[3]['possibly_lighter']
  end

  def test_creates_and_drops_databases
    @setup.send(:name=, @@weird_db_name)
    @setup.send(:create_database)
    PG.connect({ dbname: @@weird_db_name, user: 'postgres' }).finish()
    @setup.send(:teardown_database)
    assert_raises 'Error' do
      PG.connect({ dbname: @@weird_db_name, user: 'postgres' }).finish()
    end
  end

  def test_creates_and_connects_to_db_if_absent
    @setup.send(:name=, @@weird_db_name)
    @setup.send(:try_to_connect)
    assert @setup.send(:db)
    PG.connect({ dbname: @@weird_db_name, user: 'postgres' }).finish()
    @setup.send(:teardown_database)
    assert_raises 'Error' do
      PG.connect({ dbname: @@weird_db_name, user: 'postgres' }).finish()
    end
  end

  def teardown
  end
end
