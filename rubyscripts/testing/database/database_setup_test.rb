require "minitest/autorun"
require './rubyscripts/testing/test_defaults'
require 'pg'
require_relative '../../logic/database/setup/database_setup'

class DatabaseSetupTest < Minitest::Test


  @@weird_db_name = 'xesgytpbt_saldutvet'

  def setup
    @setup = DatabaseSetup.new()
  end


  def test_creates_and_drops_databases
    @setup.send(:name=, @@weird_db_name)
    @setup.send(:create_database)
    PG.connect({ dbname: @@weird_db_name, user: 'postgres' }).finish()
    @setup.send(:teardown_database)
    assert_raises 'Error' do
      PG.connect({ dbname: @@weird_db_name, user: 'postgres' }).finish()
    end
  end

  def test_creates_and_connects_to_db_if_absent
    @setup.send(:name=, @@weird_db_name)
    @setup.send(:try_to_connect)
    assert @setup.send(:db)
    PG.connect({ dbname: @@weird_db_name, user: 'postgres' }).finish()
    @setup.send(:teardown_database)
    assert_raises 'Error' do
      PG.connect({ dbname: @@weird_db_name, user: 'postgres' }).finish()
    end
  end

  def teardown
  end
end
