# frozen_string_literal: true

# ------------ Enum ---------------

# Example:
class Conversation < ActiveRecord::Base
  enum status: %i[active archived]
end

# conversation.update! status: 0
conversation.active!
conversation.active? # => true
conversation.status  # => "active"

# conversation.update! status: 1
conversation.archived!
conversation.archived? # => true
conversation.status    # => "archived"

# conversation.status = 1
conversation.status = 'archived'

conversation.status = nil
conversation.status.nil? # => true
conversation.status      # => nil

# Example: map the relation between attribute and database integer
class Conversation < ActiveRecord::Base
  enum status: { active: 0, archived: 1 }
end

# prefix and suffix
class Conversation < ActiveRecord::Base
  enum status: %i[active archived], _suffix: true
  enum comments_status: %i[active inactive], _prefix: :comments
end
