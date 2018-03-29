require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/info_saver'

class InfoSaverTest < DatabaseTester

  @@scored_selections = {:selections=>[{:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}}, :score=>2}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}}, :score=>2}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}}, :score=>2}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}}, :score=>1}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}}, :score=>1}], :state_score=>2}

    @@scored_selections2 = {:selections=>[{:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}}, :score=>0}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}}, :score=>2}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}}, :score=>2}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}}, :score=>1}, {:selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}}, :score=>1}], :state_score=>2}


  def setup
    setup_database_for_testing
    @saver = InfoSaver.new()
  end

  def test_correctly_identifies_low_scored_selections
    @saver.send(:selections=, @@scored_selections[:selections])
    @saver.send(:gather_possible_selections)
    assert_equal 2, @saver.send(:possible_selections).length
    assert_equal 1, @saver.send(:possible_selections)[0][:score]

    @saver.send(:selections=, @@scored_selections2[:selections])
    @saver.send(:gather_possible_selections)
    assert_equal 1, @saver.send(:possible_selections).length
    assert_equal 0, @saver.send(:possible_selections)[0][:score]
  end

  def teardown
    teardown_database
  end
end
