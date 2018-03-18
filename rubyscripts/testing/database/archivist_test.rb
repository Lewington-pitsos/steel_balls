require "minitest/autorun"
require_relative '../../logic/database/archivist'

class ArchivistTest < Minitest::Test

  def setup
    @archivist = Archivist.new()
  end

  def test_connects_to_database
    databse = @archivist.send(:db).exec('SELECT current_database();').values[0][0]

    assert_equal 'postgres', database
  end

  def teardown
  end
end
