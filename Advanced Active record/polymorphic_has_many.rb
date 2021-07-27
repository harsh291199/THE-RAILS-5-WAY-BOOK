# frozen_string_literal: true

# ------------ Polymorphic has_many Relationships ---------------

# Example:
class Comment < ActiveRecord::Base
  belongs_to :timesheet
  belongs_to :expense_report
end

# Example: The Interface
class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
end

class Timesheet < ActiveRecord::Base
  has_many :comments, as: :commentable
end

class BillableWeek < ActiveRecord::Base
  has_many :comments, as: :commentable
end

