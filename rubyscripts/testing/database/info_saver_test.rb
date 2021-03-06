require './rubyscripts/testing/database_tester'
require './rubyscripts/logic/database/info_saver'
require './rubyscripts/logic/database/lookup/tree_lookup'

class InfoSaverTest < DatabaseTester

  @@placeholder_state = {
    unknown: 8,
    possibly_heavier: 0,
    possibly_lighter: 0,
    normal: 0
  }

  @@rated_selections = [{:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>2, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>2, :possibly_heavier=>0, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>0, :possibly_heavier=>1, :normal=>7}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>1, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}]}}, {:rating=>29, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>0, :possibly_heavier=>0, :possibly_lighter=>2, :normal=>0}, :states=>[{:rating=>29, :state=>{:unknown=>1, :possibly_lighter=>0, :possibly_heavier=>2, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>37, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>0, :normal=>7}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>1, :possibly_lighter=>0, :normal=>0}, :states=>[{:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}, {:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}]}}, {:rating=>31, :selection=>{:left=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>0, :normal=>1}, :right=>{:unknown=>1, :possibly_heavier=>0, :possibly_lighter=>1, :normal=>0}, :states=>[{:rating=>34, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>1, :normal=>6}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>2, :possibly_heavier=>1, :normal=>5}}, {:rating=>31, :state=>{:unknown=>0, :possibly_lighter=>1, :possibly_heavier=>2, :normal=>5}}]}}]


  @@resulting_tree = {"unknown"=>"8", "possibly_lighter"=>"0", "possibly_heavier"=>"0", "normal"=>"0", "score"=>nil, "fully_scored"=>"f", "selections"=>[{"right"=>{"unknown"=>"0", "possibly_lighter"=>"0", "possibly_heavier"=>"2", "normal"=>"0"}, "left"=>{"unknown"=>"1", "possibly_lighter"=>"0", "possibly_heavier"=>"0", "normal"=>"1"}, "states"=>[{"unknown"=>"1", "possibly_lighter"=>"2", "possibly_heavier"=>"0", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"0", "possibly_heavier"=>"1", "normal"=>"7", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"1", "possibly_heavier"=>"2", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}]}, {"right"=>{"unknown"=>"0", "possibly_lighter"=>"1", "possibly_heavier"=>"1", "normal"=>"0"}, "left"=>{"unknown"=>"1", "possibly_lighter"=>"0", "possibly_heavier"=>"0", "normal"=>"1"}, "states"=>[{"unknown"=>"1", "possibly_lighter"=>"1", "possibly_heavier"=>"1", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"1", "possibly_heavier"=>"1", "normal"=>"6", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}]}, {"right"=>{"unknown"=>"0", "possibly_lighter"=>"2", "possibly_heavier"=>"0", "normal"=>"0"}, "left"=>{"unknown"=>"1", "possibly_lighter"=>"0", "possibly_heavier"=>"0", "normal"=>"1"}, "states"=>[{"unknown"=>"1", "possibly_lighter"=>"0", "possibly_heavier"=>"2", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"2", "possibly_heavier"=>"1", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"1", "possibly_heavier"=>"0", "normal"=>"7", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}]}, {"right"=>{"unknown"=>"1", "possibly_lighter"=>"0", "possibly_heavier"=>"1", "normal"=>"0"}, "left"=>{"unknown"=>"1", "possibly_lighter"=>"0", "possibly_heavier"=>"0", "normal"=>"1"}, "states"=>[{"unknown"=>"0", "possibly_lighter"=>"1", "possibly_heavier"=>"2", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"1", "possibly_heavier"=>"1", "normal"=>"6", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"2", "possibly_heavier"=>"1", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}]}, {"right"=>{"unknown"=>"1", "possibly_lighter"=>"1", "possibly_heavier"=>"0", "normal"=>"0"}, "left"=>{"unknown"=>"1", "possibly_lighter"=>"0", "possibly_heavier"=>"0", "normal"=>"1"}, "states"=>[{"unknown"=>"0", "possibly_lighter"=>"1", "possibly_heavier"=>"1", "normal"=>"6", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"2", "possibly_heavier"=>"1", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}, {"unknown"=>"0", "possibly_lighter"=>"1", "possibly_heavier"=>"2", "normal"=>"5", "score"=>nil, "fully_scored"=>"f", "selections"=>[]}]}]}


  @@get_all_ratings = <<~CMD
    SELECT rating FROM possible_selections ORDER BY rating DESC;
  CMD

  def setup
    setup_database_for_testing()
    add_defaults(@@placeholder_state)
    @saver = InfoSaver.new()
    @lookup = TreeLookup.new($DATABASE_NAME)
  end

  def test_saves_data_properly
    @saver.save_everything(@@rated_selections, 1)
    @lookup.build_tree
    assert_equal @@rated_selections.length, @lookup.tree['selections'].length

    ratings = @db.exec(@@get_all_ratings)

    sels = @@rated_selections.sort do |sel1, sel2|
      sel2[:rating] <=> sel1[:rating]
    end


    sels.each_with_index do |selection, index|
      assert_equal selection[:selection][:states].length, @lookup.tree['selections'][index]['states'].length

      assert_equal selection[:rating], ratings[index]['rating'].to_i
    end
  end

  def teardown
    teardown_database
  end
end
