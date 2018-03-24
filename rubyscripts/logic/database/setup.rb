# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'
require_relative './save_helper'

class Setup < Archivist

  include SaveHelper

  @@default_states = [
    { unknown: 2, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 3, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 4, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 5, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 6, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 7, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 8, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 9, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 10, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 11, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 12, possibly_heavier: 0, possibly_lighter: 0, normal: 0 },
    { unknown: 13, possibly_heavier: 0, possibly_lighter: 0, normal: 0 }
  ]

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

  def initialize(name=@@database_name)
    super(name)
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

  def add_default_states
    @@default_states.each do |state|
      save(state, 'scored_states')
    end
  end

  private

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

=begin
setup = Setup.new('test_steel_balls')

setup.send(:clear_database)

setup.send(:setup_tables)
=end
