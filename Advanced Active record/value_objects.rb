# frozen_string_literal: true

# ------------ Value Objects ---------------

# Example:
class Person < ActiveRecord::Base
  def address
    @address ||= Address.new(address_city, address_state)
  end

  def address=(address)
    self[:address_city] = address.city
    self[:address_state] = address.state
    @address = address
  end
end

# Address class
class Address
  attr_reader :city, :state

  def initialize(city, state)
    @city = city
    @state = state
  end

  def ==(other)
    city == other.city && state == other.state
  end
end

gary = Person.create(name: 'Gary')

gary.address_city = 'Brooklyn'

gary.address_state = 'NY'

gary.address
# <Address:0x007fcbfcce0188 @city="Brooklyn", @state="NY">
