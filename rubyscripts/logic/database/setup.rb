# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'

class Setup < Archivist

  def initialize(name)
    super(name)
  end

  def setup_if_needed

    setup_tables_if_needed
  end

  private

  def setup_tables_if_needed
    if tables_missing
      setup_tables
    end
  end

  def tables_missing

    begin
      @db.exec('SELECT * FROM Scored_States;')
      @db.exec('SELECT * FROM Scored_Selections;')
      @db.exec('SELECT * FROM States_Selections;')
      @db.exec('SELECT * FROM Selector_Sides;')
    rescue
      puts "At least one table is missing"
      return true
    end

    false
  end

  def setup_tables

  end

end
