require_relative './archivist'

class Searcher < Archivist

  def initialize(name)
    super(name)
  end

  def rubify(pg_result, column_name)
    # returns the actual number value represented within the pg result, or nil if the pg result came up with no matches
    # only works for maximum 1 length results
    if pg_result.ntuples == 1
      pg_result[0][column_name].to_i
    else
      nil
    end
  end
end
