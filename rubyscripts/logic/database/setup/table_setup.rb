# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.
require 'pg'
require './rubyscripts/logic/database/save_helper'
require_relative '../setup'

class TableSetup < Setup

  include SaveHelper

  @@scored_states_setup = <<~COMMAND
    CREATE TABLE scored_states (
      id serial,
      unknown INTEGER NOT NULL DEFAULT 0,
      possibly_lighter INTEGER NOT NULL DEFAULT 0,
      possibly_heavier INTEGER NOT NULL DEFAULT 0,
      normal INTEGER NOT NULL DEFAULT 0,
      rating INTEGER DEFAULT 0,
      score INTEGER DEFAULT 999,
      fully_scored BOOLEAN DEFAULT FALSE,
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
    CREATE TABLE possible_selections (
      id serial,
      state_id INTEGER REFERENCES scored_states(id) ON DELETE CASCADE,
      selection_id INTEGER REFERENCES selections(id) ON DELETE CASCADE,
      rating INTEGER NOT NULL DEFAULT 0,
      score INTEGER DEFAULT NULL,
      fully_scored BOOLEAN DEFAULT FALSE,
      PRIMARY KEY(id)
    )
  COMMAND

  @@selections_prev_states_setup = <<~COMMAND
    CREATE TABLE resulting_states (
      id serial,
      possible_selection_id INTEGER REFERENCES possible_selections(id) ON DELETE CASCADE,
      state_id INTEGER REFERENCES scored_states(id) ON DELETE CASCADE,
      PRIMARY KEY(id)
    )
  COMMAND

  @@drop_all_tables = <<~COMMAND
    DROP TABLE IF EXISTS resulting_states;
    DROP TABLE IF EXISTS possible_selections;
    DROP TABLE IF EXISTS selections;
    DROP TABLE IF EXISTS selection_sides;
    DROP TABLE IF EXISTS scored_states;
  COMMAND

  @@suppress_warnings = <<~COMMAND
    SET client_min_messages TO WARNING;
  COMMAND

  def initialize(name=$DATABASE_NAME)
    super(name)
    spin_up
    setup_if_needed
  end

  def setup_if_needed
    if tables_missing
      setup_tables
    end
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

  private

  attr_accessor :db, :name

  def tables_missing

    begin
      @db.exec('SELECT * FROM scored_states;')
      @db.exec('SELECT * FROM selection_sides;')
      @db.exec('SELECT * FROM selections;')
      @db.exec('SELECT * FROM possible_selections;')
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
