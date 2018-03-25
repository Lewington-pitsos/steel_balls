# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './save_helper'

class Setup

  include SaveHelper

  @@scored_states_setup = <<~COMMAND
    CREATE TABLE scored_states (
      id serial,
      unknown INTEGER NOT NULL DEFAULT 0,
      possibly_lighter INTEGER NOT NULL DEFAULT 0,
      possibly_heavier INTEGER NOT NULL DEFAULT 0,
      normal INTEGER NOT NULL DEFAULT 0,
      score INTEGER DEFAULT NULL,
      PRIMARY KEY(id)
    )
  COMMAND

  @@selection_sides_setup = <<~COMMAND
    CREATE TABLE selection_sides (
      id serial,
      unknown INTEGER NOT NULL DEFAULT 0,
      possibly_lighter INTEGER NOT NULL DEFAULT 0,
      possibly_heavier INTEGER NOT NULL DEFAULT 0,
      normal INTEGER NOT NULL DEFAULT 0,
      CONSTRAINT unique_side UNIQUE (unknown, possibly_lighter, possibly_heavier, normal),
      PRIMARY KEY(id)
    )
  COMMAND

  @@scored_selections_setup = <<~COMMAND
    CREATE TABLE selections (
      id serial,
      left_id INTEGER REFERENCES selection_sides(id) ON DELETE CASCADE,
      right_id INTEGER REFERENCES selection_sides(id) ON DELETE CASCADE,
      PRIMARY KEY(id)
    )
  COMMAND

  @@states_prev_selections_setup = <<~COMMAND
    CREATE TABLE optimal_selections (
      id serial,
      state_id INTEGER REFERENCES scored_states(id) ON DELETE CASCADE,
      selection_id INTEGER REFERENCES selections(id) ON DELETE CASCADE,
      PRIMARY KEY(id)
    )
  COMMAND

  @@selections_prev_states_setup = <<~COMMAND
    CREATE TABLE resulting_states (
      id serial,
      optimal_selection_id INTEGER REFERENCES optimal_selections(id) ON DELETE CASCADE,
      state_id INTEGER REFERENCES scored_states(id) ON DELETE CASCADE,
      PRIMARY KEY(id)
    )
  COMMAND



  @@drop_all_tables = <<~COMMAND
    DROP TABLE IF EXISTS resulting_states;
    DROP TABLE IF EXISTS optimal_selections;
    DROP TABLE IF EXISTS selections;
    DROP TABLE IF EXISTS selection_sides;
    DROP TABLE IF EXISTS scored_states;
  COMMAND

  @@suppress_warnings = <<~COMMAND
    SET client_min_messages TO WARNING;
  COMMAND

  def initialize()
    @db = nil
    try_to_connect
  end

  def setup_if_needed
    setup_tables_if_needed
  end

  def suppress_warnings
    @db.exec(@@suppress_warnings)
  end

  def clear_database
    @db.exec(@@drop_all_tables)
  end

  def add_default_states(*args)
    args.each do |state|
      save(state, 'scored_states')
    end
  end

  def close
    @db.finish()
  end

  private

  attr_accessor :db

  def spin_up
    @db = PG.connect({ dbname: $DATABASE_NAME, user: 'postgres' })
  end

  def create_database
    db = PG.connect({ dbname: 'postgres', user: 'postgres' })
    db.exec("CREATE DATABASE #{$DATABASE_NAME};")
    db.finish()
  end

  def teardown_database
    @db.finish()
    closing_db = PG.connect({ dbname: 'postgres', user: 'postgres' })
    closing_db.exec("DROP DATABASE #{$DATABASE_NAME};")
    closing_db.finish()
  end

  def try_to_connect
    begin
      spin_up
    rescue
      create_database
      spin_up
    end

    unless @db
      puts "ERROR: Could not create #{$DATABASE_NAME} database"
    end
  end

  def setup_tables_if_needed
    if tables_missing
      setup_tables
    end
  end

  def tables_missing

    begin
      @db.exec('SELECT * FROM scored_states;')
      @db.exec('SELECT * FROM selection_sides;')
      @db.exec('SELECT * FROM selections;')
      @db.exec('SELECT * FROM optimal_selections;')
      @db.exec('SELECT * FROM resulting_states;')
    rescue
      return true
    end

    false
  end

  def setup_tables
    @db.exec(@@scored_states_setup)
    @db.exec(@@selection_sides_setup)
    @db.exec(@@scored_selections_setup)
    @db.exec(@@states_prev_selections_setup)
    @db.exec(@@selections_prev_states_setup)
    true
  end
end
