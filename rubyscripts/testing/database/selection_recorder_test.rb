require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/selection_recorder'

class SelectionRecorderTest < DatabaseTester

  @@example_side = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@example_side2 = {
    unknown: 4,
    possibly_heavier: 2,
    possibly_lighter: 0,
    normal: 0
  }

  @@example_side3 = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 1
  }

  @@example_selection = {
    left: @@example_side,
    right: @@example_side2
  }

  def setup
    setup_database_for_testing
    @recorder = SelectionRecorder.new($DATABASE_NAME)
  end

  def test_records_single_side
    @recorder.send(:save, @@example_side)
    row = get_all('selection_sides')[0]

    @@example_side.each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end

    assert_raises 'Error' do
      get_all('selection_sides')[1]
    end

    @recorder.send(:save, @@example_side2)
    row = get_all('selection_sides')[1]
    @@example_side2.each do |mark, num|
      assert_equal num, row[mark.to_s].to_i
    end
  end

  def test_returns_last_side_id
    id = @recorder.send(:save, @@example_side)
    assert_equal 1, id
    id = @recorder.send(:save, @@example_side2)
    assert_equal 2, id
    id = @recorder.send(:save, @@example_side3)
    assert_equal 3, id
  end

  def test_retrives_correct_id_from_recorded_sides
    @recorder.send(:save, @@example_side)
    @recorder.send(:save, @@example_side2)
    @recorder.send(:save, @@example_side3)

    id = @recorder.send(:get_id, @@example_side)
    assert_equal 1, id
    id = @recorder.send(:get_id, @@example_side2)
    assert_equal 2, id
    id = @recorder.send(:get_id, @@example_side3)
    assert_equal 3, id
  end

  def test_returns_nil_for_non_recorded_sides
    refute @recorder.send(:get_id, @@example_side)
    refute @recorder.send(:get_id, @@example_side2)
  end

  def test_saves_selection_object_properly
    @recorder.send(:save, @@example_side)
    @recorder.send(:save, @@example_side2)
    @recorder.send(:left_id=, 1)
    @recorder.send(:right_id=, 2)
    @recorder.send(:save_selection)

  end


  def teardown
    teardown_database
  end
end
