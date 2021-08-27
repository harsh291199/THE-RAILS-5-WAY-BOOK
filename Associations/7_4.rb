# frozen_string_literal: true

# ------------------- 7.4 Has Many Associations -----------------------------

# Just like it sounds, the has_many association enables you to define a relationship in
# which one model has many other models that belong to it.

class User < ActiveRecord::Base
  has_many :timesheets
  has_many :expense_reports
end

# -------------------- 7.4.1 Methods -----------------------------

user.timesheets.where(submitted: true).order('updated_at desc')
user.timesheets.late # assuming a scope :late defined on the Timesheet class

# 7.4.1.1 <<(*records) and create(attributes = {})

# 7.4.1.2 any? and many?

# 7.4.1.3 average(column_name, options = {})

# 7.4.1.4 build(attributes={}, &block)
user.timesheets.build(attributes)
user.timesheets.new(attributes) # same as calling build

# 7.4.1.5 calculate(operation, column_name, options = {})

# 7.4.1.6 clear

# 7.4.1.7 count(column_name=nil, options={})

# 7.4.1.8 create(attributes, &block) and create!(attributes, &block)
User.new.timesheets.create
# ActiveRecord::RecordNotSaved: You cannot call create unless the parent is saved

# 7.4.1.9 delete(*records) and delete_all

# 7.4.1.10 destroy(*records) and destroy_all

# 7.4.1.11 empty?
# Simply calls size.zero?

# 7.4.1.12 find(id)

# 7.4.1.13 first(*args)
# Returns the first associated record.

c = Client.first
# <Client id: 1, name: "Taigan", ...>

c.billing_codes.first(2)
# [#<BillingCode id: 1, client_id: 1, code: "MTG"...>,
# <BillingCode id: 2, client_id: 1, code: "DEV"...>]

# 7.4.1.14 ids
# Returns an array of primary keys for the associated objects

# 7.4.1.15 include?(record)

# 7.4.1.16 last(*args)
# Returns the last associated record.

# 7.4.1.17 length

# 7.4.1.18 maximum(column_name, options = {})

# 7.4.1.19 minimum(column_name, options = {})

# 7.4.1.20 new(attributes, &block)

# 7.4.1.21 pluck(*column_names)
# Returns an array of attribute values.

# 7.4.1.22 replace(other_array)
# Replaces the collection of records currently inside the proxy with other_array.

# 7.4.1.23 select(select=nil, &block)

user.timesheets.select(:submitted).to_a
# [<Timesheet id: nil, submitted: false>,
# <Timesheet id: nil, submitted: true>]

user.timesheets.select(%i[id submitted]).to_a
# [<Timesheet id: 1, submitted: false>,
# <Timesheet id: 2, submitted: true>]

user.timesheets.select(:*, 'calc_something(col1, col2) as delta').to_a
# <Timesheet id: 1, ..., delta: 1234>

# 7.4.1.24 size

# 7.4.1.25 sum(column_name, options = {})

# 7.4.1.26 uniq

# -------------------- 7.4.2 Options -----------------------------

# 7.4.2.1 after_add

# 7.4.2.2 after_remove

# 7.4.2.3 as

# 7.4.2.4 autosave

# 7.4.2.5 before_add

# Simple Example:
has_many :unchangable_posts,
         class_name: 'Post',
         before_add: :raise_exception

private

def raise_exception(_object)
  raise "You can't add a post"
end

# You can use with lambda
has_many :unchangable_posts,
         class_name: 'Post',
         before_add: -> { raise "You can't add a post" }

# 7.4.2.6 before_remove: callback

# User class
class User < ActiveRecord::Base
  has_many :timesheets,
           before_remove: :check_timesheet_destruction,
           dependent: :destroy

  protected

  def check_timesheet_destruction(timesheet)
    raise TimesheetError, 'Cannot destroy a submitted timesheet.' if timesheet.submitted?
  end
end

# 7.4.2.7 class_name
has_many :draft_timesheets, -> { where(submitted: false) },
         class_name: 'Timesheet'

# 7.4.2.8 dependent

# 7.4.2.9 foreign_key

# 7.4.2.10 inverse_of
has_many :timesheets, inverse_of: :user

# 7.4.2.11 primary_key

# 7.4.2.12 source and source_type

# 7.4.2.13 through

# 7.4.2.14 validate

# -------------------- 7.4.3 Scoping -----------------------------

# The has_many association provides the capability to customize the query used
# by the database to retrieve the association collection.

# 7.4.3.1 where(*conditions)
has_many :pending_comments, -> { where(approved: true) },
         class_name: 'Comment'

# 7.4.3.2 extending(*extending_modules)

# 7.4.3.3 group(*args)

# 7.4.3.4 having(*clauses)

# 7.4.3.5 includes(*associations)
class Timesheet < ActiveRecord::Base
  has_many :billable_weeks, -> { includes(:billing_code) }
end

# 7.4.3.6 limit(integer)

# 7.4.3.7 offset(integer)

# 7.4.3.8 order(*clauses)

# 7.4.3.9 readonly

# 7.4.3.10 select(expression)

# 7.4.3.11 distinct
