require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/lookup'
require './rubyscripts/logic/state_manager'


class LookupTest < DatabaseTester

  @@starting_rated_state = {
    state: {
      unknown: 3,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    },
    rating: 0
  }

  @@other_state = {
    unknown: 1,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 2
  }

  def setup
    setup_database_for_testing
    add_defaults(@@starting_rated_state[:state])
    $WINNING_RATING = 12
    $DEFAULT_LENGTH = 3
    @manager = StateManager.new(@@starting_rated_state)
    @manager.score()

    @lookup = Lookup.new($DATABASE_NAME)
  end

  def test_retrival_by_id_works
    assert_equal '2', @lookup.send(:get_by_id, '1', 'scored_states')['score']
    assert_equal '1', @lookup.send(:get_by_id, '5', 'scored_states')['score']
    assert_raises 'Error' do
      @lookup.get_by_id('6', 'scored_states')
    end

    assert_equal '1', @lookup.send(:get_by_id, '1', 'selections')['left_id']
    assert_equal '2', @lookup.send(:get_by_id, '1', 'selections')['right_id']
    assert_equal '1', @lookup.send(:get_by_id, '4', 'selections')['left_id']
    assert_equal '4', @lookup.send(:get_by_id, '4', 'selections')['right_id']
    assert_raises 'Error' do
      @lookup.get_by_id('8', 'selections')
    end

    assert_equal '0', @lookup.send(:get_by_id, '1', 'selection_sides')['unknown']
    assert_equal '1', @lookup.send(:get_by_id, '2', 'selection_sides')['unknown']
    assert_equal '1', @lookup.send(:get_by_id, '1', 'selection_sides')['normal']
  end

  def test_retrival_by_id_removes_ids
    refute @lookup.send(:get_by_id, '1', 'scored_states')['id']
    refute @lookup.send(:get_by_id, '5', 'scored_states')['id']
    refute @lookup.send(:get_by_id, '1', 'selection_sides')['id']
    refute @lookup.send(:get_by_id, '2', 'selection_sides')['id']
    refute @lookup.send(:get_by_id, '4', 'selections')['id']
  end

  def test_creates_proper_first_state
    assert_equal $DEFAULT_LENGTH, @lookup.send(:first_state)[:unknown]

    $DEFAULT_LENGTH = 9
    assert_equal $DEFAULT_LENGTH, @lookup.send(:first_state)[:unknown]
  end

  def test_gets_correct_state_via_state_values
    assert_equal '1', @lookup.send(:state_id_by_values, @@starting_rated_state[:state])
    assert_equal '2', @lookup.send(:state_id_by_values, @@other_state)
  end

  def test_queries_all_possible_selections
    selections = @lookup.send(:possible_selections, '1')
    assert_equal 1, selections.ntuples
    selections.each do |sel|
      assert_equal '7', sel['selection_id']
    end

    selections = @lookup.send(:possible_selections, '5')
    selections.each_with_index do |sel, index|
      assert_equal (index + 3).to_s, sel['selection_id']
    end
  end

  def test_returns_correct_resulting_states
    selections = @lookup.send(:resulting_states, '1')
    assert_equal 2, selections.ntuples
    selections.each_with_index do |sel, index|
      assert_equal (index + 3).to_s, sel['state_id']
    end
  end

  def test_gathers_possible_selection_ids
    selections = @lookup.send(:possible_selections, '1')
    ids = @lookup.send(:ids_from, selections, 'selection_id')

    assert_equal 1, ids.length
    assert_equal '7', ids[0]

    selections = @lookup.send(:possible_selections, '5')
    ids = @lookup.send(:ids_from, selections, 'selection_id')

    assert_equal 4, ids.length
    assert_equal '3', ids[0]
    assert_equal '5', ids[2]
  end

  def test_gathers_resultign_state_ids
    states = @lookup.send(:resulting_states, '1')
    ids = @lookup.send(:ids_from, states, 'state_id')

    assert_equal 2, ids.length
    assert_equal '3', ids[0]

    states = @lookup.send(:resulting_states, '6')
    ids = @lookup.send(:ids_from, states, 'state_id')

    assert_equal 2, ids.length
    assert_equal '4', ids[0]
    assert_equal '3', ids[1]
  end

  def test_builds_all_states_for_winning_selection
    states = @lookup.send(:build_resulting_states, '6')
    assert_equal 2, states.length
    assert_equal '2', states[0]['normal']
    assert_equal '1', states[1]['possibly_heavier']
    assert_empty states[0]['selections']
    assert_empty states[1]['selections']

    states = @lookup.send(:build_resulting_states, '2')
    assert_equal 2, states.length
    assert_equal '2', states[0]['normal']
    assert_equal '2', states[1]['normal']
    assert_empty states[0]['selections']
    assert_empty states[1]['selections']
  end

  def test_builds_all_selections_for_nearly_winning_states
    selections = @lookup.send(:build_possible_selections, '2')
    assert_equal 2, selections.length
    assert_equal '1', selections[0]['right']['unknown']
    assert_equal '1', selections[1]['right']['normal']
    states = selections[1]['states']
    assert_equal 2, states.length
    assert_equal '2', states[0]['normal']
    assert_equal '2', states[1]['normal']
  end

  def test_built_selections_removed_side_ids
    selections = @lookup.send(:build_possible_selections, '2')
    selections.each do |selection|
      refute selection['left_id']
      refute selection['right_id']
    end

    selections = @lookup.send(:build_possible_selections, '3')
    selections.each do |selection|
      refute selection['left_id']
      refute selection['right_id']
    end
  end

  def test_builds_single_selection_properly
    selection = @lookup.send(:build_selection, '2')
    assert_equal 2, selection['states'].length
    assert selection['left']
    assert_equal '0', selection['right']['unknown']
    assert_equal '1', selection['right']['normal']
  end

  def test_builds_whole_tree
    @lookup.build_tree
    assert_equal '2', @lookup.tree['score']
    assert_equal 1, @lookup.tree['selections'].length
    assert_equal '1', @lookup.tree['selections'][0]['right']['unknown']
    assert_equal 2, @lookup.tree['selections'][0]['states'].length
    assert_equal '1', @lookup.tree['selections'][0]['states'][1]['possibly_heavier']
    assert_equal 4, @lookup.tree['selections'][0]['states'][1]['selections'].length
    assert_equal '1', @lookup.tree['selections'][0]['states'][1]['selections'][0]['right']['possibly_heavier']
  end

  def test_simplified_tree_renders_correctly
    lookup2 = Lookup.new($DATABASE_NAME, true)
    lookup2.build_tree
    assert_equal '2', lookup2.tree['score']
    assert_equal 1, lookup2.tree['selections'].length
    assert_equal 1, lookup2.tree['selections'][0]['states'][0]['selections'].length
    assert_equal 1, lookup2.tree['selections'][0]['states'][1]['selections'].length
  end

  def teardown
    $WINNING_RATING = 37
    $DEFAULT_LENGTH = 8
    teardown_database
  end
end
