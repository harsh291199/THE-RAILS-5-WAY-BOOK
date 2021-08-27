# frozen_string_literal: true

# ------------ Tokens ---------------

# ------ Generating Secure Tokens

# Example: Traditional way
class User < ActiveRecord::Base
  before_create :generate_token

  private

  def generate_token
    self.token = loop do
      t = SecureRandom.hex(16)
      break t unless User.where(token: t).exists?
    end
  end
end

# Example: macro-style class method
class User < ApplicationRecord
  has_secure_token
end

user = User.create
# => #<User id: ...

user.token
# => "njHcvhKSwX9toZKEe9YETA8C"


# ------- Regenerating Secure tokens

# just call regenerate_<name_of_token> :

user.regenerate_token
# (0.1ms) begin transaction
# User Exists (0.1ms) SELECT 1 AS one FROM "users"...
# SQL (0.2ms) UPDATE "users" SET "updated_at" = ?, "token" = ? WHERE
# "users"."id" = ? [["updated_at", 2016-11-21 22:20:33 UTC], ["token",
# "YDSNntcYiVKm8ueYy2zAXhqq"], ["id", 2]]
# (8.1ms) commit transaction
# => true

u.token
# => "YDSNntcYiVKm8ueYy2zAXhqq"
