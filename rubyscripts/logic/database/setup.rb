# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'

class Setup < Archivist

  @@scored_states_setup = <<~COMMAND
    CREATE TABLE scored_states (
      id serial,
      unknown INTEGER NOT NULL DEFAULT 0,
      possibly_lighter INTEGER NOT NULL DEFAULT 0,
      possibly_heavier INTEGER NOT NULL DEFAULT 0,
      normal INTEGER NOT NULL DEFAULT 0,
      score INTEGER NOT NULL DEFAULT 0,
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
      PRIMARY KEY(id)
    )
  COMMAND

  @@scored_selections_setup = <<~COMMAND
    CREATE TABLE scored_selections (
      id serial,
      left_id INTEGER REFERENCES selection_sides(id) ON DELETE CASCADE,
      right_id INTEGER REFERENCES selection_sides(id) ON DELETE CASCADE,
      score INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY(id)
    )
  COMMAND

  @@states_prev_selections_setup = <<~COMMAND
    CREATE TABLE states_prev_selections (
      id serial,
      state_id INTEGER REFERENCES scored_states(id) ON DELETE CASCADE,
      prev_selection_id INTEGER REFERENCES scored_selections(id) ON DELETE CASCADE,
      PRIMARY KEY(id)
    )
  COMMAND

  @@selections_prev_states_setup = <<~COMMAND
    CREATE TABLE selections_prev_states (
      id serial,
      selection_id INTEGER REFERENCES scored_selections(id) ON DELETE CASCADE,
      prev_state_id INTEGER REFERENCES scored_states(id) ON DELETE CASCADE,
      PRIMARY KEY(id)
    )
  COMMAND



  @@drop_all_tables = <<~COMMAND
    DROP TABLE IF EXISTS states_prev_selections;
    DROP TABLE IF EXISTS selections_prev_states;
    DROP TABLE IF EXISTS scored_selections;
    DROP TABLE IF EXISTS selection_sides;
    DROP TABLE IF EXISTS scored_states;
  COMMAND

  @@suppress_warnings = <<~COMMAND
    SET client_min_messages TO WARNING;
  COMMAND

  def initialize(name)
    super(name)
  end

  def setup_if_needed

    setup_tables_if_needed
  end

  def suppress_warnings
    @db.exec(@@suppress_warnings)
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
      @db.exec('SELECT * FROM scored_selections;')
      @db.exec('SELECT * FROM states_prev_selections;')
      @db.exec('SELECT * FROM selections_prev_states;')
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

  def clear_database
    @db.exec(@@drop_all_tables)
  end
end

=begin
setup = Setup.new('test_steel_balls')

setup.send(:clear_database)

setup.send(:setup_tables)
=end
