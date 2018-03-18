# checks if the database with the proper tables are all setup. Sets them up if not, otherwise does nothing.

require_relative './archivist'

class ScoreChceker < Archivist

  def initialize(name)
    super(name)
  end
end
