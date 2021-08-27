# frozen_string_literal: true

# --------------------  7.1 The Association Hierarchy------------------------------

# Associations typically appear as methods on Active Record model objects.
# For example, the method timesheets might represent the timesheets
# associated with a given user.

user.timesheets

# --------------------- 7.2 One-to-Many Relationships ------------------------------

# Example of One-to-many relationships

class User < ActiveRecord::Base
  has_many :timesheets
  has_many :expense_reports
end

# Timesheets and expense reports should be linked in the opposite direction as well,

class Timesheet < ActiveRecord::Base
  belongs_to :user
end

class ExpenseReport < ActiveRecord::Base
  belongs_to :user
end

obie = User.find(1)
# <User id: 1...>

obie.timesheets << Timesheet.new
# <ActiveRecord::Associations::CollectionProxy [#<Timesheet id: 1 ...]>

obie.timesheets
# <ActiveRecord::Associations::CollectionProxy [#<Timesheet id: 1 ...]>

# ---------7.2.1 Adding Associated Objects to a Collection

obie.timesheets.reload

obie.timesheets.create
# <ActiveRecord::Associations::CollectionProxy [#<Timesheet id: 1, user_id: 1 ...]>
