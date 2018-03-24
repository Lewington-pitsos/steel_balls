require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require 'pg'
require_relative '../../logic/database/setup'

class SetupTest < Minitest::Test

  def setup
    @setup = Setup.new($DATABASE_NAME)
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
    @setup.add_default_states
    states = PG.connect({ dbname: $DATABASE_NAME, user: 'postgres' }).exec(
      'SELECT * FROM scored_states'
    )

    assert_equal '2', states[0]['unknown']
    assert_equal '0', states[0]['normal']
    assert_equal '0', states[0]['possibly_heavier']
    assert_equal '0', states[0]['possibly_lighter']
    assert_equal '9', states[7]['unknown']
    assert_equal '12', states[10]['unknown']
  end

  def teardown
  end
end
