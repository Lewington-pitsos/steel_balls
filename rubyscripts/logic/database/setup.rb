class Setup

  def initialize(name=$DATABASE_NAME)
    @name = name
  end

  def close
    @db.finish()
  end

  private

  def spin_up
    @db = PG.connect({ dbname: @name, user: 'postgres' })
  end
end
