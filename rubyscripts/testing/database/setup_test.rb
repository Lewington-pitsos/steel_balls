require "minitest/autorun"
require_relative '../../logic/database/setup'

class ArchivistTest < Minitest::Test

  def setup
    @setup.send(:clear_database)
    @setup = Setup.new('test_steel_balls')
  end

  def test_identifies_empty_database
    assert @setup.send(:tables_missing)
  end

  def test_identifies_set_up_database
    @setup.send(:setup_tables)
    refute @setup.send(:tables_missing)
  end

  def test_sets_up_empty_database
    assert @setup.send(:setup_tables)
  end

  def teardown
    @setup.send(:clear_database)
  end
end
