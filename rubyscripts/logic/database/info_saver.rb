# takes an array of scored selections, a state and a state score

require_relative './info_saver/state_recorder'
require_relative './info_saver/score_recorder'
require_relative './info_saver/selection_recorder'

class InfoSaver

  def initialize()
    @state = {}
    @score = 0
    @selections = []
    @optimal_selections = []

    @main_state_id = 0

    @state_recorder = StateRecorder.new()
    @score_recorder = ScoreRecorder.new()
    @selection_recorder = SelectionRecorder.new()
  end

  def save_everything(scored_state_info)
    parse(scored_state_info)
    save_state_score
    gather_optimal_selections
    @optmial_selections.each do |selection|
      @state_recorder.record_states(selection)
      new_state_ids = @state_recorder.ids
      @selection_recorder.record_selection(selection, @main_state_id, new_state_ids)
    end
  end

  private

  attr_reader :optimal_selections
  attr_writer :selections

  def parse(scored_state_info)
    @state = scored_state_info[:state]
    @score = scored_state_info[:score]
    @selections = scored_state_info[:selections]
  end

  def save_state_score
    @main_state_id = @score_recorder.record_score(@state, @score)
  end

  def gather_optimal_selections
    # saves a list of all the selections which share the lowest score equally
    @optimal_selections = []
    min = @selections[0][:score]

    @selections.each do |selection|
      score = selection[:score]
      if score < min
        min = score
        @optimal_selections = [selection]
      elsif score == min
        @optimal_selections << selection
      end
    end
  end
end
