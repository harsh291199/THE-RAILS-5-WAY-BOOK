# frozen_string_literal: true

# ------------ Batch Operations ---------------

# ------- Creating many records

# Example:
CSV.foreach('path/to/import/items.csv') do |row|
  items << "('#{row[0]}','#{row[1]}'...)"
end

BATCH_SIZE = 1000

while items.any?
  next_batch = items.shift(BATCH_SIZE)
  sql = "INSERT INTO items(legacy_id, name, ...)
    VALUES " + next_batch.join(', ')
  ActiveRecord::Base.connection.execute(sql)
end

# ------- Reading many records at once

# Example: with find_each
namespace :export do
    task :call-list do
    puts "name,phone"
    Contact.where(...).find_each do |contact|
      puts "#{contact.name},#{contact.phone}"
    end

# Example: find_in_batches
namespace :export do
    task :call-list do
    puts "batch_num,name,phone"
    Contact.where(...).find_in_batches.with_index do |contacts, n|
      contacts.each do
        puts "#{n},#{contact.name},#{contact.phone}"
    end


# ------- Updating many records at once

# Example:

Event.update_all starts_at: Date.today
# SQL (8.4ms) UPDATE "events" SET "starts_at" = '2016-11-28'
# => 1

Event.where(id: 1).update_all starts_at: Date.today
# SQL (0.1ms) UPDATE "events" SET "starts_at" = '2016-11-28' WHERE "events"."id" = ? [["id", 1]]
# => 0

# ----------- Bulk deletion

# Example: Deletion of Dependent Data
class Account
  has_many :registrations
  has_many :persons, through: :registrations
end

class Registration
  belongs_to :account
  belongs_to :person
end

class Person
  has_many :registrations
  has_many :accounts, through: :registrations
end

Person.where(criteria).delete_all

# Example: Deleting via Associations
class Person
    has_many :registrations, dependent: :destroy
    has_many :accounts, through: :registrations
end

person.registrations.delete_all

