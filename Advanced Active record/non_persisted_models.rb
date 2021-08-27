# frozen_string_literal: true

# ------------ Non-persisted Models ---------------

# Example:
class Contact
  include ActiveModel::Model
  attr_accessor :name, :email, :message

  validates :name, presence: true
  validates :email,
            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/ },
            presence: true
  validates :message, length: { maximum: 1000 }, presence: true
end
