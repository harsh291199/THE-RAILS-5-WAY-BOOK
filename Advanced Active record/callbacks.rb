# frozen_string_literal: true

# ------------ Callbacks ------------------------

# Example:
class Beethoven < ActiveRecord::Base
  before_destroy :last_words

  protected

  def last_words
    logger.info 'Friends applaud, the comedy is over'
  end
end

# Example: One-Liners
class Napoleon < ActiveRecord::Base
  before_destroy { logger.info 'Josephine...' }
  # ...
end

# List of Callbacks

# before_validation
# after_validation
# before_save
# around_save
# before_create (for new records) and before_update (for existing records)
# around_create (for new records) and around_update (for existing records)
# after_create (for new records) and after_update (for existing records)
# after_save

# Skipping Callback Execution
# The following Active Record methods, when executed, do not run any

# decrement
# decrement_counter
# delete
# delete_all
# increment
# increment_counter
# toggle
# touch
# update_column
# update_columns
# update_all
# update_counters

# Example: before_validation
class CreditCard < ActiveRecord::Base
  before_validation on: :create do
    # Strip everything in the number except digits
    self.number = number.gsub(/[^0-9]/, '')
  end
end

# Example: before_save
class Address < ActiveRecord::Base
  before_save :geocode
  validates_presence_of :street, :city, :state, :country
  # ...
  def to_s
    [street, city, state, country].compact.join(', ')
  end

  protected

  def geocode
    result = Geocoder.coordinates(to_s)
    self.latitude = result.first
    self.longitude = result.last
  end
end

# Example: before_destroy

class Account < ActiveRecord::Base
  before_destroy do
    update_attribute(:deleted_at, Time.current)
    throw(:abort)
  end
  # ...
end

# Example: after_destroy
def destroy_attached_files
  Paperclip.log('Deleting attachments.')
  each_attachment do |_name, attachment|
    attachment.send(:flush_deletes)
  end
end

# Example: after_initialize and after_find
class User < ActiveRecord::Base
  serialize :preferences
  # ...

  protected

  def after_initialize
    self.preferences ||= {}
  end
end

# Callback Classes
# It is common enough to want to reuse callback code for more than one object that
# Rails gives you

# Example: Callback class
class MarkDeleted
  def self.before_destroy(model)
    model.update_attribute(:deleted_at, Time.current)
    false
  end
end

# you can use callback class like this:
class Account < ActiveRecord::Base
  before_destroy MarkDeleted
  # ...
end

class Invoice < ActiveRecord::Base
  before_destroy MarkDeleted
  # ...
end

# Example: Multiple Callback Methods in One Class
class Auditor
  def initialize(audit_log)
    @audit_log = audit_log
  end

  def after_create(model)
    @audit_log.created(model.inspect)
  end

  def after_update(model)
    @audit_log.updated(model.inspect)
  end

  def after_destroy(model)
    @audit_log.destroyed(model.inspect)
  end
end


