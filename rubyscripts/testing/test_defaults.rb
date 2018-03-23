# ======================== Ball Number ========================
# i.e. how maany balls are we weighing. The $WINNING_RATING depends on how many balls are being weighed

$WINNING_RATING = 37
$DEFAULT_LENGTH = 8


# ======================== Score Weighting ========================
# this is used to generate state ratings

$NORMAL_SCORE = 5
$HALF_SCORE = 2
$UNKNOWN_SCORE = 0


# ======================== Database Name ========================
# I.e. which database to use

$DATABASE_NAME = 'test_steel_balls'

# ======================== Common Files ========================
# we require them here so we don't need to require them lots of times in different tests

require_relative '../logic/shared/arrangement_generator/ball_generator'
require_relative '../logic/shared/arrangement_generator/ball'
require_relative '../logic/state_evaluator/selection_overseer/state_expander'
require_relative '../logic/database/setup'
require_relative '../logic/database/archivist'
require_relative '../logic/state_evaluator/selection_overseer/omni_selector/whole_selection_generator/selection_side_generator/shover_manager/mark_counter.rb'
