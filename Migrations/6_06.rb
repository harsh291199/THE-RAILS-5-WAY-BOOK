# frozen_string_literal: true

# Topic-6.6: Database seeding

# The automatically created file db/seeds.rb is a default location for
# creating seed data for your database.

# At its simplest, the contents of seed.rb is simply a series of create! statements
# that generate baseline data for your application, whether it is default or related to
# configuration. For example, let us add an admin user and some billing codes to our
# time and expenses app:

# User.create!(login: 'admin',
#      email: 'admin@example.com',
#      :password: '123', password_confirmation: '123',
#      authorized_approver: true)

client = Client.create!(name: 'Workbeast', code: 'BEAST')
client.billing_codes.create!(name: 'Meetings', code: 'MTG')
client.billing_codes.create!(name: 'Development', code: 'DEV')

# An alternative would be to use first_or_create methods to make seeding idempotent.

c = Client.where(name: 'Workbeast', code: 'BEAST').first_or_create!
c.billing_codes.where(name: 'Meetings', code: 'MTG').first_or_create!
c.billing_codes.where(name: 'Development', code: 'DEV').first_or_create!

# Another common seeding practice worth mentioning is calling delete_all prior
# to creating new records, so that seeding does not generate duplicate records.

# User.delete_all
# User.create!(login: 'admin', ...

# Client.delete_all
# client = Client.create!(name: 'Workbeast', ...
