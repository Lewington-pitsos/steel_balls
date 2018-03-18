require "minitest/autorun"
require_relative '../../logic/database/setup'

class ArchivistTest < Minitest::Test

  def setup
    @setup = Setup.new('test_steel_balls')
  end

  def test_identifies_empty_database
    assert @setup.send(:tables_missing)
  end

  def sets_up_empty_database

  end

  def teardown
  end
end
