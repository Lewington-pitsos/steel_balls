require "minitest/autorun"
require "set"
require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/state_evaluator/rating_overseer'

class RatingOverseerTest < DatabaseTester

  @@small_state = {
    unknown: 2,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@medium_state = {
    unknown: 4,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@light_state = {
    unknown: 3,
    possibly_heavier: 0,
    possibly_lighter: 1,
    normal: 0
  }

  @@medium_selection = [
    {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}]},
    {:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}, :right=>[{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}]}
  ]

  @@medium_ratings = [{:rating=>10, :selection=>{:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}, :right=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>1}, :states=>[{:rating=>10, :state=>{:unknown=>2, :possibly_lighter=>0, :possibly_heavier=>0, :normal=>2}}, {:rating=>14, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>2}}]}, :id=>1}, {:rating=>8, :selection=>{:left=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}, :right=>{:normal=>0, :possibly_lighter=>0, :possibly_heavier=>0, :unknown=>2}, :states=>[{:rating=>8, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>2, :normal=>0}}]}, :id=>2}]



  def setup
    setup_database_for_testing
    @overseer = RatingOverseer.new(@@medium_state, 0, 1)
  end

  def test_gathers_arrangements_correctly
    @overseer.send(:get_all_arranments)
    assert_equal 8, @overseer.send(:arrangements).length

    overseer = RatingOverseer.new(@@small_state, 0, 1)
    overseer.send(:get_all_arranments)
    assert_equal 4, overseer.send(:arrangements).length

    overseer = RatingOverseer.new(@@light_state, 0, 1)
    overseer.send(:get_all_arranments)
    assert_equal 7, overseer.send(:arrangements).length
  end

  def test_gathers_selections_correctly
    @overseer.send(:get_all_selection_orders)

    assert_equal @@medium_selection.to_s, @overseer.send(:selection_orders).to_s
  end

  def test_merges_properly
    selections = @overseer.send(:generate_selections_to_weigh)

    selections.each do |selection|
      assert selection[:balls]
      assert_equal 8, selection[:balls].length
    end
  end

  def test_arrangeemnt_deep_cloning_on_merge
    selections = @overseer.send(:generate_selections_to_weigh)

    all_balls = Set[]

    selections.each do |selection|
      selection[:balls].each do |ball|
        assert all_balls.add?(ball)
      end
    end
  end

  def test_rates_selections_properly
    ratings = @overseer.rated_weighed_selections

    assert_equal 2, ratings.length
    assert_equal 10, ratings[0][:rating]
    assert_equal 8, ratings[1][:rating]
    assert_equal @@medium_ratings.to_s, ratings.to_s
  end

  def teardown
    teardown_database
  end
end
