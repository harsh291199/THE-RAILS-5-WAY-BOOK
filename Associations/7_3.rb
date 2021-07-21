# frozen_string_literal: true

# ------------------- 7.3 Belongs to Associations -----------------------------

# The belongs_to class method expresses a relationship from one Active Record
# object to a single associated object for which it has a foreign key attribute.

timesheet = Timesheet.create
# <Timesheet id: 1409, user_id: nil...>

timesheet.user = obie
# <User id: 1, login: "obie"...>

timesheet.user.login
# "obie"

timesheet.reload
# <Timesheet id: 1409, user_id: nil...>

# ----------------- 7.3.1 Methods --------------

#----------7.3.1.1 Reloading

ts = Timesheet.first
# <Timesheet id: 3, user_id: 1...>

ts.user.object_id
# 70279541443160

ts.reload_user && ts.user.object_id
# 70279549419744

# -------7.3.1.2 Building and Creating Related Objects via the Association

ts = Timesheet.first
# <Timesheet id: 3, user_id: 1...>

ts.build_user
# <User id: nil, email: nil...>

bc = BillingCode.first
# <BillingCode id: 1, code: "TRAVEL"...>

bc.create_client
# <Client id: 1, name=>nil, code=>nil...>

# ---------------- 7.3.2 Options -----------------

# 7.3.2.1 autosave

# 7.3.2.2 class_name
class Timesheet < ActiveRecord::Base
  belongs_to :approver, class_name: 'User'
  belongs_to :user
end

# 7.3.2.3 counter_cache
# counter_cache: true
# counter_cache: :number_of_children

# 7.3.2.4 dependent

# 7.3.2.5 foreign_key
# without the explicit option, Rails would guess administrator_id
belongs_to :administrator, foreign_key: 'admin_user_id'

# 7.3.2.6 inverse_of

# 7.3.2.7 optional

# 7.3.2.8 polymorphic
# Comment class using polymorphic belongs to relationship
create_table :comments do |t|
  t.text :body
  t.references :subject, polymorphic: true
  # references can be used as a shortcut for following two statements
  # t.integer :subject_id
  # t.string :subject_type
  t.timestamps
end

class Comment < ActiveRecord::Base
  belongs_to :subject, polymorphic: true
end

class ExpenseReport < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :subject
end

class Timesheet < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :subject
end

# 7.3.2.9 primary_key

# 7.3.2.10 required

# 7.3.2.11 touch
class Timesheet < ActiveRecord::Base
  belongs_to :user, touch: 'timesheets_updated_at'
end

# 7.3.2.12 validate

# --------------------- 7.3.3 Scopes ----------------

# Sometimes the need arises to have a relationship that must satisfy certain conditions
# in order for it to be valid. To facilitate this, Rails allows us to supply query criteria,
# or a scope, to a relationship definition as an optional second block argument.

# 7.3.3.1 where(*conditions)
class Timesheet < ActiveRecord::Base
  belongs_to :approver,
             -> { where(approver: true) },
             class_name: 'User'
  # ...
end

# 7.3.3.2 includes
belongs_to :post, -> { includes(:author) }

# 7.3.3.3 select

# 7.3.3.4 readonly
class Timesheet < ActiveRecord::Base
  belongs_to :user, ~> { readonly }
  # ...
end

t = Timesheet.first
# <Timesheet id: 1, submitted: nil, user_id: 1...>

t.user
# <User id: 1, login: "admin"...>

t.user.save
# ActiveRecord::ReadOnlyRecord: ActiveRecord::ReadOnlyRecord
