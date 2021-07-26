# frozen_string_literal: true

# ------------ Scopes ------------------------

# Example:
class User < ActiveRecord::Base
  scope :delinquent, -> { where('timesheets_updated_at < ?', 1.week.ago) }
end

User.delinquent
# => [#<User id: 2, timesheets_updated_at: "2013-04-20 20:02:13"...>]

# we can use like this also:
def self.delinquent
  where('timesheets_updated_at < ?', 1.week.ago)
end

# Example: Scope with arguments
class BillableWeek < ActiveRecord::Base
  scope :newer_than, ->(date) { where('start_date > ?', date) }
end

BillableWeek.newer_than(Date.today)

# Example: Chaining scopes
class Timesheet < ActiveRecord::Base
  scope :submitted, -> { where(submitted: true) }
  scope :underutilized, -> { submitted.where('total_hours < 40') }
end

# Example: Scopes with joins
scope :tardy, -> { joins(:timesheets).where('timesheets.submitted_at <= ?', 7.days.ago).group('users.id') }

# Example: Scope Combinations
scope :tardy, -> { joins(:timesheets).group('users.id').merge(Timesheet.late) }

# Example: Default Scopes
class Timesheet < ActiveRecord::Base
  default_scope { where(status: 'open') }
end

# Example: Scopes for CRUD
scope :perfect, -> { submitted.where(total_hours: 40) }

Timesheet.perfect.build
# => #<Timesheet id: nil, submitted: true, user_id: nil, total_hours: 40 ...>


