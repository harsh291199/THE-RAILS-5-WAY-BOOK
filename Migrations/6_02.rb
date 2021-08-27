# frozen_string_literal: true

# Topic-6.2: Defining Columns

# Columns can be added to a table using either the column method, inside the block
# of a create_table statement, or with the add_column method.
create_table :clients do |t|
  t.column :name, :string
end

add_column :clients, :code, :string
add_column :clients, :created_at, :datetime

# 6.2.1 Column Type Mappings

# 6.2.1.1 Native Database Column Types

# postgresql_adapter.rb :
NATIVE_DATABASE_TYPES = {
  primary_key: 'serial primary key',
  string:
    { name: 'character varying' },
  text:
    { name: 'text' },
  integer:
    { name: 'integer' },
  float:
    { name: 'float' },
  decimal:
    { name: 'decimal' },
  datetime:
    { name: 'timestamp' },
  time:
    { name: 'time' },
  date:
    { name: 'date' },
  daterange:
    { name: 'daterange' },
  numrange:
    { name: 'numrange' },
  tsrange:
    { name: 'tsrange' },
  tstzrange:
    { name: 'tstzrange' },
  int4range:
    { name: 'int4range' },
  int8range:
    { name: 'int8range' },
  binary:
    { name: 'bytea' },
  boolean:
    { name: 'boolean' },
  xml:
    { name: 'xml' },
  tsvector:
    { name: 'tsvector' },
  hstore:
    { name: 'hstore' },
  inet:
    { name: 'inet' },
  cidr:
    { name: 'cidr' },
  macaddr:
    { name: 'macaddr' },
  uuid:
    { name: 'uuid' },
  json:
    { name: 'json' },
  jsonb:
    { name: 'jsonb' },
  ltree:
    { name: 'ltree' },
  citext:
    { name: 'citext' },
  point:
    { name: 'point' },
  line:
    { name: 'line' },
  lseg:
    { name: 'lseg' },
  box:
    { name: 'box' },
  path:
    { name: 'path' },
  polygon:
    { name: 'polygon' },
  circle:
    { name: 'circle' },
  bit:
    { name: 'bit' },
  bit_varying:
    { name: 'bit varying' },
  money:
    { name: 'money' }
}

# 6.2.2 Column Options
# For many column types, just specifying type is not enough information.
# All column declarations accept the following options:

# default: value
# limit: size
# null: false
# index: true
# comment: text

# 6.2.2.1 Decimal Precision
# Columns declared as type :decimal accept the following options:

# precision: number
# scale: number

# 6.2.3 Column Type Gotchas
# The choice of column type is not necessarily a simple choice and depends on both
# the database you are using and the requirements of your application.

# :binary
# :boolean
# :datetime and :timestamp
# :time
# :decimal
# :float
# :integer and :string
# :text

# 6.2.4 “Magic” Timestamp Columns
# Active Record will automatically timestamp create operations if the table has
# columns named created_at or created_on .

# Automatic timestamping can be turned off globally, by setting the following
# variable in an initializer.
ActiveRecord::Base.record_timestamps = false

# 6.2.5 More Command-Line Magic

# rails g migration AddDetailsToProducts 'price:decimal{5,2}' supplier:references{polymorphic}

# will produce a migration that looks like this:

# class AddDetailsToProducts
class AddDetailsToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :price, :decimal, precision: 5, scale: 2
    add_reference :products, :supplier, polymorphic: true
  end
end
