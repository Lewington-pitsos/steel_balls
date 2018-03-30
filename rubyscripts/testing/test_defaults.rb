require 'logger'

# ======================== Ball Number ========================
# i.e. how maany balls are we weighing. The $WINNING_RATING depends on how many balls are being weighed

$WINNING_RATING = 37
$DEFAULT_LENGTH = 8


# ======================== Score Weighting ========================
# this is used to generate state ratings

$DEFAULT_RATING = 0
$NORMAL_SCORE = 5
$HALF_SCORE = 2
$UNKNOWN_SCORE = 0


# ======================== Database Name ========================
# I.e. which database to use

$DATABASE_NAME = 'test_steel_balls'

# ======================== Calculation Breadth ========================
# I.e. how many rated selections to bother calculating for each run

$BREADTH = 999


# ======================== Logger ========================
# We want the same logger to be accessible everywhere

$LOGGER = Logger.new('test.log')

# ======================== Common Files ========================
# we require them here so we don't need to require them lots of times in different tests

require './rubyscripts/logic/state_evaluator/rating_overseer/state_expander/arrangement_generator/ball_generator'
require './rubyscripts/logic/state_evaluator/rating_overseer/state_expander/arrangement_generator/ball_generator/ball'
require './rubyscripts/logic/state_evaluator/rating_overseer/state_expander'
require './rubyscripts/logic/database/setup'
require './rubyscripts/logic/database/archivist'
require './rubyscripts/logic/state_evaluator/rating_overseer/omni_selector/whole_selection_generator/selection_side_generator/shover_manager/mark_counter.rb'
require './rubyscripts/logic/database/info_saver/state_recorder'
