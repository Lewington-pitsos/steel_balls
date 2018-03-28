class Setup

  def initialize(name=$DATABASE_NAME)
    @name = name
    @db = nil
    try_to_connect
  end

  def close
    @db.finish()
  end
end
