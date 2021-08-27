# frozen_string_literal: true

# Topic-6.7: Database-Related Tasks

# The following command-line tasks are included by default in boilerplate Rails projects.

# 6.7.1 db:create and db:create:all
# Create the database defined in config/database.yml for the current Rails.env.

# 6.7.2 db:drop and db:drop:all
# Drops the database for the current RAILS_ENV.

# 6.7.3 db:forward and db:rollback
# The db:rollback task moves your database schema back one version.
# The db:forward task moves your database schema forward one version.

# 6.7.4 db:migrate
# Applies all pending migrations.
# rails db:migrate VERSION=20130313005347

# 6.7.5 db:migrate:down
# This task will invoke the down method of the specified migration only.
# $ rails db:migrate:down VERSION=20130316172801

# 6.7.6 db:migrate:up
# This task will invoke the up method of the specified migration only.
# $ rails db:migrate:up VERSION=20130316172801

# 6.7.7 db:migrate:redo
# Executes the down method of the latest migration file, immediately followed by its up method.
# rails db:migrate:redo

# 6.7.8 db:migrate:reset
# Resets your database for the current environment using your migrations

# 6.7.9 db:migrate:status
# Displays the status of all existing migrations in a nicely formatted table.
# rails db:migrate:status

# 6.7.10 db:reset and db:setup
# The db:setup creates the database for the current environment, loads the schema
# from db/schema.rb , then loads the seed data.

# The similar db:reset task does the same thing except that 
# it drops and recreates the database first.

# 6.7.11 db:schema:dump
# Creates a db/schema.rb file that can be portably used against any DB supported
# by Active Record.

# 6.7.12 db:schema:load
# Loads schema.rb file into the database for the current environment.

# 6.7.13 db:seed
# Loads the seed data from db/seeds.rb

# 6.7.14 db:structure:dump
# Dumps the database structure to a SQL file containing raw DDL code in a format
# corresponding to the database driver specified in database.yml for your current
# environment.
# rake db:structure:dump

# 6.7.15 db:test:prepare
# Checks for pending migrations and loads the test schema by
# doing a db:schema:dump followed by a db:schema:load.

# 6.7.16 db:version
# Returns the timestamp of the latest migration file that has been run.
