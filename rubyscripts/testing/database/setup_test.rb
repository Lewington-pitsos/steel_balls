require "minitest/autorun"
require_relative '../../logic/database/setup'

class ArchivistTest < Minitest::Test

  def setup
    @setup = Setup.new('test_steel_balls')
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

  def teardown
  end
end
