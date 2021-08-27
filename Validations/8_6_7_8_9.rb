# frozen_string_literal: true

# ------------------------------ 8.6 Custom Validation Techniques --------------------------------

# When declarative validation doesn’t meet your needs, Rails gives you a few custom techniques.

# ------------------- 8.6.1 Custom Validation Macros ---------------------------

# Example:
class LikeValidator < ActiveModel::EachValidator
  def initialize(options)
    @with = options[:with]
    super
  end

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "does not appear to be like #{@with}") unless value[@with]
  end
end

# Our model code would change to
class Report < ActiveRecord::Base
  validates :name, like: { with: 'Report' }
end

# ------------------ 8.6.2 Create a Custom Validator Class -----------------------

# Example:
class RandomlyValidator < ActiveModel::Validator
  def validate(record)
    record.errors[:base] << 'FAIL #1' unless first_hurdle(record)
    record.errors[:base] << 'FAIL #2' unless second_hurdle(record)
    record.errors[:base] << 'FAIL #3' unless third_hurdle(record)
  end

  private

  def first_hurdle(_record)
    rand > 0.3
  end

  def second_hurdle(_record)
    rand > 0.6
  end

  def third_hurdle(_record)
    rand > 0.9
  end
end

# Use your new custom validator in a model with the validates_with macro.
class Report < ActiveRecord::Base
  validates_with RandomlyValidator
end

# ------------------ 8.6.3 Add a validate Method to Your Model -----------------------

# Example:
class CompletelyLameTotalExample < ActiveRecord::Base
  def validate
    errors[:total] << "doesn't add up" if total != (attr1 + attr2 + attr3)
  end
end

# ------------------------------- 8.7 Skipping Validations -------------------------------

# The methods update_attribute and update_column don’t invoke validations,
# yet their companion method update does.

# ------------------------------- 8.8 Working with the Errors Hash-------------------------

# Some methods are provided to enable you to add validation errors to the
# collection manually and alter the state of the Errors object.

# errors[:base] = msg
# errors[:attribute] = msg
# clear

# ----------------- 8.8.1 Checking for Errors --------------------------

user.errors[:login]
# => ["zed is already registered"]

user.errors[:password]
# => []

# Alternatively, you could also access full error messages for a
# specific attribute using the full_messages_for method.

user.errors.full_messages_for(:email)
# => ["Email can't be blank"]

# ----------------------------- 8.9 Testing Validations with Shoulda ------------------------

# Even though validations are declarative code, if you’re doing TDD then you’ll
# want to specify them before writing them. Luckily, Thoughtbot’s Shoulda Matchers
# library 3 contains a number of matchers designed to easily test validations.

describe Post do
  it { should validate_uniqueness_of(:title) }
  it { should validate_presence_of(:body).with_message(/wtf/) }
  it { should validate_presence_of(:title) }
  it { should validate_numericality_of(:user_id) }
end

describe User do
  it { should_not allow_value('blah').for(:email) }
  it { should_not allow_value('b lah').for(:email) }
  it { should allow_value('a@b.com').for(:email) }
  it { should allow_value('asdf@asdf.com').for(:email) }
  it { should ensure_length_of(:email).is_at_least(1).is_at_most(100) }
  it { should ensure_inclusion_of(:age).in_range(1..100) }
end
