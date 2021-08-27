# frozen_string_literal: true

# Topic-6.5: Database Schema

# The file db/schema.rb is generated every time you migrate and reflects the latest
# status of your database schema. The top of a schema file looks something like this.

ActiveRecord::Schema.define(version: 20_161_123_170_510) do
  create_table 'auctions', force: :cascade do |t|
    t.string 'name'
    t.text 'description'
    t.datetime 'ends_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.datetime 'closes_at'
    t.integer 'user_id'
  end
end

# If you need to recreate your database on anoth-er server,
# you should be using db:schema:load , not running all the migrations from scratch.