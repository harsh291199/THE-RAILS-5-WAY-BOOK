# frozen_string_literal: true

# ------------ Foreign Key Names and Indexes ---------------

# Example:
class User < ActiveRecord::Base
  has_many :auctions, dependent: :destroy
  validates :name, presence: true
end

class Auction < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  has_many :bids, dependent: :destroy
end

def change
  add_foreign_key :auctions, :users
end

# ------------ Removing Foreign Keys -------------

# Example: Three different ways

remove_foreign_key :accounts, :branches

remove_foreign_key :accounts, column: :owner_id

remove_foreign_key :accounts, name: :special_fk_name


