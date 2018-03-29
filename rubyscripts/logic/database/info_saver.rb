# takes an array of scored selections, a state and a state score

require_relative './info_saver/state_recorder'
require_relative './info_saver/score_recorder'
require_relative './info_saver/selection_recorder'

class InfoSaver

  def initialize()
    @state = {}
    @score = 0
    @selections = []

    @main_state_id = 0

    @state_recorder = StateRecorder.new()
    @selection_recorder = SelectionRecorder.new()
  end

  def save_everything(rated_selections, state_id)
    rated_selections.each do |selection|
      @state_recorder.record_states(selection[:selection])
      new_state_ids = @state_recorder.ids
      @selection_recorder.save_selection_data(selection, state_id, new_state_ids)
    end

    close_everything()
  end

  private

  attr_reader :possible_selections
  attr_writer :selections

  def close_everything
    @state_recorder.close()
    @score_recorder.close()
    @selection_recorder.close()
  end
end
