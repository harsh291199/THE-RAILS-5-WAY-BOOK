# frozen_string_literal: true

# ------------------- 7.6 One-to-One Relationships -----------------------------

# ------------- 7.6.1 has_one -------------------

class Avatar < ActiveRecord::Base
  belongs_to :user
end

class User < ActiveRecord::Base
  has_one :avatar
  # ...
end

u = User.first

u.avatar
# nil

u.build_avatar(url: '/avatars/smiling')
# <Avatar id: nil, url: "/avatars/smiling", user_id: 1>

u.avatar.save
# true

# ----------- 7.6.2 Using has_one together with has_many ----------

class User < ActiveRecord::Base
  has_many :timesheets

  has_one :latest_sheet,
          -> { order('created_at desc') },
          class_name: 'Timesheet'
end

# ---------------- 7.6.3 Options -------------------

# 7.6.3.1 as
# 7.6.3.2 class_name
# 7.6.3.3 dependent

# ----------------- 7.6.4 Scopes --------------------

# 7.6.4.1 where(*conditions)
class User < ActiveRecord::Base
  has_one :manager, -> ( where(type: 'manager')),
  class_name: 'Person'
end

# 7.6.4.2 order(*clauses)
class User < ActiveRecord::Base
  has_one :latest_timesheet, -> { order('created_at desc') },
  class_name: 'Timesheet'
end

# 7.6.4.3 readonly
# Sets the record in the association to read-only mode, which prevents saving it.

