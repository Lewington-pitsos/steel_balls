require "minitest/autorun"
require_relative '../../logic/database/archivist'

class ArchivistTest < Minitest::Test

  def setup
    @archivist = Archivist.new('test_steel_balls')
  end

  def test_sets_up_empty_database
    database = @archivist.send(:db).exec('SELECT current_database();').values[0][0]

    assert_equal 'test_steel_balls', database
  end

  def teardown
  end
end
