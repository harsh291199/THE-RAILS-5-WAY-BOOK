# frozen_string_literal: true

# --------------------------------- Chapter 8: Validations -------------------------------------------------

# ----------------------------------- 8.1 Finding Errors -----------------------------------------

# On a model object, a series of steps to find errors is taken as follows (slightly simplified):
# 1. Clear the errors collection.
# 2. Run validations.
# 3. Return whether the model’s errors collection is now empty or not.

# --------------------------- 8.2 The Simple Declarative Validations ------------------------------

# ------------ 8.2.1 validates_absence_of -----------------

# Example:
class Account < ActiveRecord::Base
  validates_absence_of :spambot_honeypot_field
end

# ------------ 8.2.2 validates_acceptance_of -----------------

# Example:
class Account < ActiveRecord::Base
  validates_acceptance_of :privacy_policy, :terms_of_service
end

class Cancellation < ActiveRecord::Base
  validates_acceptance_of :account_cancellation, accept: 'YES'
end

# ------------ 8.2.3 validates_associated ---------------------

# You probably don’t need to use this particular validation nowadays since
# has_many associations default to validate: true.

# ----------- 8.2.4 validates_confirmation_of ---------------------

# Example:
class Account < ActiveRecord::Base
  validates_confirmation_of :password
end

# ----------- 8.2.5 validates_each ---------------

# Example:
class Invoice < ActiveRecord::Base
  validates_each :supplier_id, :purchase_order do |record, attr, value|
    record.errors.add(attr) unless PurchasingSystem.validate(attr, value)
  end
end

# ---------- 8.2.6 validates_format_of --------------------

# Example:
class Person < ActiveRecord::Base
  validates_format_of :email,
                      with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
end

# ------------ 8.2.7 validates_inclusion_of and validates_exclusion_of -----------------

# Example:
class Person < ActiveRecord::Base
  validates_inclusion_of :gender, in: %w[m f], message: '- O RLY?'
  # ...
end

# Example:
class Account < ActiveRecord::Base
  validates_exclusion_of :username, in: %w[admin superuser],
                                    message: ', huh? Borat says "Naughty, naughty!"'
  # ...
end

# -------------- 8.2.8 validates_length_of -------------------------

# Example:
class Account < ActiveRecord::Base
  validates_length_of :login, minimum: 5
end

# -------------- 8.2.8.1 Constraint Options

# Example:
class Account < ActiveRecord::Base
  validates_length_of :username, within: 5..20
end

# To specify an exact length of an attribute, use the :is option:
class Account < ActiveRecord::Base
  validates_length_of :account_number, is: 16
end

# --------------- 8.2.8.2 Error Message Options

# Example:
class Account < ActiveRecord::Base
  validates_length_of :account_number, is: 16,
                                       wrong_length: 'should be %{count} characters long'
end

# ---------------- 8.2.9 validates_numericality_of -----------------------------

# Example:
class Account < ActiveRecord::Base
  validates_numericality_of :account_number, only_integer: true
end

# The following comparison options are also available:
# :equal_to
# :greater_than
# :greater_than_or_equal_to
# :less_than
# :less_than_or_equal_to
# :other_than

# ------------------ 8.2.10 validates_presence_of -----------------------------

# Example:
class Account < ActiveRecord::Base
  validates_presence_of :username, :email, :account_number
end

# --------- 8.2.10.1 Validating the Presence and/or Existence of Associated Objects

# Example:
class Timesheet < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id
  validate :user_exists

  protected

  def user_exists
    errors.add(:user_id, "doesn't exist") unless User.exists?(user_id)
  end
end

# ---------------- 8.2.11 validates_uniqueness_of -----------------------------

# Example:
class Account < ActiveRecord::Base
  validates_uniqueness_of :username
end

# Example:
class Address < ActiveRecord::Base
  validates_uniqueness_of :line_two, scope: [:line_one, :city, :zip]
end

# ----------- 8.2.11.1 Enforcing Uniqueness of Join Models

# Example:
class Student < ActiveRecord::Base
  has_many :registrations
  has_many :courses, through: :registrations
end

class Registration < ActiveRecord::Base
  belongs_to :student
  belongs_to :course
end

class Course < ActiveRecord::Base
  has_many :registrations
  has_many :students, through: :registrations
end

# Example of uniqueness
class Registration < ActiveRecord::Base
  belongs_to :student
  belongs_to :course

  validates_uniqueness_of :student_id, scope: :course_id,
                                       message: 'can only register once per course'
end

# ------------- 8.2.11.2 Limit Constraint Lookup

# Example:
class Article < ActiveRecord::Base
  validates_uniqueness_of :title,
                          conditions: -> { where.not(published_at: nil) }
  # ...
end

# ------------------------------ 8.2.12 validates_with -----------------------

# Example:
class EmailValidator < ActiveRecord::Validator
  def validate
    record.errors[:email] << 'is not valid' unless
    record.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
  end
end

class Account < ActiveRecord::Base
  validates_with EmailValidator
end

# ----------------------------- 8.2.13 RecordInvalid --------------------------

u = User.new
# <User ...>

u.save!
# ActiveRecord::RecordInvalid: Validation failed: Name can't be blank,
# Password confirmation can't be blank, Password is too short (minimum
# is 5 characters), Email can't be blank, Email address format is bad

