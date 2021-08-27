# frozen_string_literal: true

# ------------------- 7.5 Many-to-Many Relationships -----------------------------

# Rails has a couple of techniques that let you represent
# many-to-many relationships in your model.
# 1.has_and_belongs_to_many
# 2.has_many :through .

# ------------------ 7.5.1 has_and_belongs_to_many -------------

# class
class CreateBillingCodesTimesheets < ActiveRecord::Migration
  def change
    create_join_table :billing_codes, :timesheets do |t|
      t.index %i[billing_code_id timesheet_id]
      t.index %i[timesheet_id billing_code_id]
    end
  end
end

class Timesheet < ActiveRecord::Base
  has_and_belongs_to_many :billing_codes
end

class BillingCode < ActiveRecord::Base
  has_and_belongs_to_many :timesheets
end

# ---------------- 7.5.1.1 Self-Referential Relationships

# class
class CreateRelatedBillingCodes < ActiveRecord::Migration
  def change
    create_table :related_billing_codes, id: false do |t|
      t.column :first_billing_code_id, :integer, null: false
      t.column :second_billing_code_id, :integer, null: false
    end
  end
end

class BillingCode < ApplicationRecord
  has_and_belongs_to_many :related,
                          join_table: 'related_billing_codes',
                          foreign_key: 'first_billing_code_id',
                          association_foreign_key: 'second_billing_code_id',
                          class_name: 'BillingCode'
end

# ----------------- 7.5.1.2 Bidirectionality

describe BillingCode do
  let(:travel_code) { BillingCode.create(code: 'TRAVEL') }
  let(:dev_code) { BillingCode.create(code: 'DEV') }

  before do
    travel_code.related << dev_code
  end
  it 'has a working related habtm association' do
    expect(travel_code.reload.related).to include(dev_code)
  end
  it 'should have a bidirectional habtm association' do
    expect(travel_code.related).to include(dev_code)
    expect(dev_code.reload.related).to include(travel_code)
  end
end

# ------------------ 7.5.1.3 Association Callbacks

# before_add
# after_add
# before_remove
# after_remove

# ------------- 7.5.1.4 Extra Columns on has_and_belongs_to_many Join Tables

# ------------- 7.5.1.5 'Real Join Models' and habtm

# ----------------------7.5.2 has_many :through -----------------------------

# ------------- 7.5.2.1 Join Models

class Client < ActiveRecord::Base
  has_many :billable_weeks
  has_many :timesheets, through: :billable_weeks
end

# We can also set up the inverse relationship, from timesheets to clients, like this:
class Timesheet < ActiveRecord::Base
  has_many :billable_weeks
  has_many :clients, through: :billable_weeks
end

# ------------ 7.5.2.2 More Than a has_and_belongs_to_many Replacement

# Grandparent class
class Grandparent < ApplicationRecord
  has_many :parents
  has_many :grand_children, through: :parents, source: :children
end

# Parent class
class Parent < ActiveRecord::Base
  belongs_to :grandparent
  has_many :children
end

# ------------- 7.5.2.3 Aggregating Associations

class User < ActiveRecord::Base
  has_many :timesheets, # ...
  has_many :billable_weeks, through: :timesheets
  # ...
end

class Timesheet < ActiveRecord::Base
  belongs_to :user
  has_many :billable_weeks, -> { includes(:billing_code) }
  # ...
end

admin = User.first
obie = User.second
client = Client.first

obie.timesheets
# <ActiveRecord::Associations::CollectionProxy []>

ts1 = obie.timesheets.create(approver: admin)
# <Timesheet id: 1 ...>

ts2 = obie.timesheets.create(approver: admin)
# <Timesheet id: 2 ...>

ts1.billable_weeks.create(start_date: 1.week.ago, client: client)
# <BillableWeek id: 1, timesheet_id: 1 ...>

ts2.billable_weeks.create(start_date: 1.week.ago, client: client)
# <BillableWeek id: 2, timesheet_id: 2 ...>

obie.billable_weeks.to_a
[# <BillableWeek id: 1, timesheet_id: 1 ...>, #<BillableWeek id: 2, timesheet_id: 2 ...>]

# ------------- 7.5.2.4 Usage Considerations and Examples

c = Client.create(name: "Trotter's Tomahawks", code: "ttom")
# <Client id: 5 ...>

c.timesheets << Timesheet.new(user: employee, )
# <ActiveRecord::Associations::CollectionProxy [#<Timesheet id: 2 ...>]>

# --------------- 7.5.2.5 Join Models and Validations
validates_uniqueness_of :client_id, scope: :timesheet_id

# ----------------------- 7.5.3 Options ---------------------------------

# 7.5.3.1 source
has_many :timesheets, through: :billable_weeks, source: :sheet

# 7.5.3.2 source_type
class Client < ActiveRecord::Base
  has_many :client_contacts
  has_many :contacts, through: :client_contacts
end

class ClientContact < ActiveRecord::Base
  belongs_to :client
  belongs_to :contact, polymorphic: true
end

class Client < ActiveRecord::Base
  has_many :client_contacts
  has_many :people, through: :client_contacts,
           source: :contact, source_type: :person
  has_many :businesses, through: :client_contacts,
           source: :contact, source_type: :business
end


# ------------------- 7.5.4 Unique Association Objects ------------------

class Client < ActiveRecord::Base
  has_many :timesheets, -> { distinct }, through: :billable_weeks
end

