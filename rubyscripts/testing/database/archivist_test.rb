require "minitest/autorun"
require_relative '../../logic/database/archivist'

class ArchivistTest < Minitest::Test

  def setup
    @archivist = Archivist.new()
  end

  def test_connects_to_database
    database = @archivist.send(:db).exec('SELECT current_database();').values[0][0]

    assert_equal 'steel_balls', database
  end

  def teardown
  end
end
