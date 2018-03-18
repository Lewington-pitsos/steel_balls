# takes an array of ball objects and a ball state and alters the obejcts so their marks match the state


require_relative './ball'

class MarkChanger

  @@default_state =  {
      unknown: 8,
      possibly_heavier: 0,
      possibly_lighter: 0,
      normal: 0
    }

  attr_accessor :state

  def initialize
    @state = @@default_state
  end

  def marked_balls(state)

  end

end
