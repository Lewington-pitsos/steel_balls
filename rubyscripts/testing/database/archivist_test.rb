require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require './rubyscripts/logic/database/archivist'

class ArchivistTest < Minitest::Test

  def setup
    @archivist = Archivist.new($DATABASE_NAME)
  end

  def test_sets_up_empty_database
    database = @archivist.send(:db).exec('SELECT current_database();').values[0][0]

    assert_equal 'test_steel_balls', database
  end

  def teardown
    @archivist.close()
  end
end
