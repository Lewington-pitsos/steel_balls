# takes in a ball state and holds a captive Omni selector and a captive State expander. It gets he Omni selector to generate all possible selection orders and the state expander to generate all possible ball arrangements. it then maps each selection order to a ball arrangement, and returns this huge agglomoration.

require_relative './selector/omni_selector'
require_relative './all_arrangements/state_expander'

class SelectionOverseer

  def initialize
    @omni_selector = OmniSelector.new()
    @state_expander = StateExpander.new()
  end

end
