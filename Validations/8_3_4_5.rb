# frozen_string_literal: true

# ------------------------------ 8.3 Common Validation Options --------------------------------

# The following options apply to all of the validation methods.

# ----------------- 8.3.1 allow_blank and allow_nil ----------------------------

# ----------------- 8.3.2 if and unless ----------------------------

# ----------------- 8.3.3 message ----------------------------

# Example:
class Account < ActiveRecord::Base
  validates_uniqueness_of :username, message: 'is already taken'
end

# ----------------- 8.3.4 on ----------------------------

# Example:
class Account < ActiveRecord::Base
  validates_uniqueness_of :email, on: :create
end

# ----------------- 8.3.5 strict ----------------------------

# Example:
class Account < ActiveRecord::Base
  validates :email, presence: { strict: EmailRequiredException }
end

# ------------------------------ 8.4 Conditional Validation --------------------------------

# ---------------- 8.4.1 Usage and Considerations -------------------------

# Example:
with_options if: :password_required? do |user|
  user.validates_presence_of :password
  user.validates_presence_of :password_confirmation
  user.validates_length_of :password, within: 4..40
  user.validates_confirmation_of :password
end

def password_required?
  encrypted_password.blank? || !password.blank?
end

# ---------------- 8.4.2 Validation Contexts -----------------------------

# Example:

class Report < ActiveRecord::Base
  validates_presence_of :name, on: :publish
end

# ReportsController class
class ReportsController < ApplicationController
  expose(:report)

  def publish
    if report.valid? :publish
      redirect_to report, notice: 'Report published'
    else
      flash.now.alert = "Can't publish unnamed reports!"
      render :show
    end
  end
end

# ------------------------------ 8.5 Short-Form Validation --------------------------------

# Example:
validates :username, presence: true,
                     format: { with: /[A-Za-z0-9]+/ },
                     length: { minimum: 3 },
                     uniqueness: true

# The following options are available for use with the validates method.

validates :unwanted, absence: { message: 'should not have been set' }

validates :terms, acceptance: { message: 'must be accepted' }

validates :email, confirmation: { message: 'is required' }

validates :username, exclusion: %w(admin superuser)

validates :email, format: /[A-Za-z0-9]+/

validates :gender, inclusion: %w(male female)

validates :username, length: 3..20

validates :quantity, numericality: { message: 'should be a number' }

validates :username, presence: { message: 'is missing (How do you expect to login without it?)' }

validates :screenname, uniqueness: { message: 'was nabbed by someone else first' }
