# takes an array of scored selections, a state and a state score

require_relative './info_saver/state_recorder'
require_relative './info_saver/score_recorder'
require_relative './info_saver/selection_recorder'

class InfoSaver

  def initialize(scored_state_info)
    @state = scored_state_info[:state]
    @score = scored_state_info[:score]
    @selections = scored_state_info[:selections]
    @optimal_selections = []

    @state_recorder = StateRecorder.new()
    @score_recorder = ScoreRecorder.new()
    @selection_recorder = SelectionRecorder.new()
  end

  def save_everything
    save_state_score
    gather_optimal_selections
    @optmial_selections.each do

    end
  end

  private

  def save_state_score
    @score_recorder.record_score(@state, @score)
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
