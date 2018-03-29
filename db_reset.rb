require './rubyscripts/logic/database/setup/database_setup'
require './rubyscripts/logic/database/setup/table_setup'



def teardown_database(name)
  table_setup = TableSetup.new(name)
  table_setup.clear_database()
  setup = DatabaseSetup.new(name)
  setup.try_dropping
end


def setup_database(name)
  setup = DatabaseSetup.new(name)
  setup.try_to_connect
  table_setup = TableSetup.new(name)
  table_setup.setup_if_needed
end

databases = [
  'steel_balls',
  'test_steel_balls'
]

databases.each do |name|
  teardown_database(name)
  setup_database(name)
end
