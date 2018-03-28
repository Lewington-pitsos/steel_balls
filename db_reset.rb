require './rubyscripts/logic/database/setup/database_setup'


def teardown_database(name)
  setup = DatabaseSetup.new(name)
  setup.try_dropping
end


def setup_database(name)
  setup = DatabaseSetup.new(name)
  setup.try_to_connect
end

databases = [
  'steel_balls',
  'test_steel_balls'
]

databases.each do |name|
  teardown_database(name)
  setup_database(name)
end
