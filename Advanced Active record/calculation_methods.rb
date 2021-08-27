# frozen_string_literal: true

# ------------ Calculation Methods ---------------

# Example: various calculation methods.

Person.calculate(:count, :all) # The same as Person.count
# SELECT AVG(age) FROM people

Person.average(:age)
# Selects the minimum age for everyone with a last name other than 'Drake'

Person.where.not(last_name: 'Drake').minimum(:age)
# Selects the minimum age for any family without any minors

Person.having('min(age) > 17').group(:last_name).minimum(:age)

# ----- Different Calculation methods

average(column_name, *options)

count(column_name, *options)

ids
# Example:
User.ids # SELECT id FROM "users"

maximum(column_name, *options)

minimum(column_name, *options)

pluck(*column_names)

# Example:
User.pluck(:id, :name)
# => [[1, 'Obie']]

User.pluck(:name)
# => ['Obie']
