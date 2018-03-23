require_relative './database/setup'

setup = Setup.new()

setup.clear_database

setup.setup_if_needed
