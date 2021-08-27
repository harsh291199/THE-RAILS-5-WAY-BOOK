# frozen_string_literal: true

# ------------ Single Table Inheritance(STI)---------------

# Example:
class Timesheet < ActiveRecord::Base
  # ...
  def self.billable_hours_outstanding_for(user)
    user.timesheets.map(&:billable_hours_outstanding).sum
  end
end

# class DraftTimesheet
class DraftTimesheet < Timesheet
  def billable_hours_outstanding
    0
  end
end

# class SubmittedTimesheet
class SubmittedTimesheet < Timesheet
  def billable_hours_outstanding
    billable_weeks.map(&:total_hours).sum
  end
end

# class PaidTimesheet
class PaidTimesheet < Timesheet
  def billable_hours_outstanding
    billable_weeks.map(&:total_hours).sum - paid_hours
  end
end

# Mapping inheritance to Database
class AddTypeToTimesheet < ActiveRecord::Migration
  def change
    add_column :timesheets, :type, :string
  end
end

d = DraftTimesheet.create

d.type
# => 'DraftTimesheet'

Timesheet.first
# => #<DraftTimesheet:0x2212354...>
