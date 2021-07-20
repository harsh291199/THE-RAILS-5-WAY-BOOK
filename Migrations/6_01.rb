# frozen_string_literal: true

# Rails 5 Way Book
# Chpter 6: Active Record Migrations

# Topic-6.1: Creating Migrations

# Rails provides a generator for creating migrations.
rails generate migration

# 6.1.1 Generator Magic

# If the migration name is of the form 'CreateXXX' and is followed by a list of column names and types, then

# rails g migration CreateProducts name:string part_number:string will generate

# class CreateProducts
class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :part_number
    end
  end
end

# bin/rails g migration AddPartNumberToProducts part_number: string will generate

# class AddPartNumberToProducts
class AddPartNumberToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :part_number, :string
  end
end

# bin/rails generate migration AddPartNumberToProducts part_number:string:index will generate

# class AddPartNumberToProducts
class AddPartNumberToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :part_number, :string
    add_index :products, :part_number
  end
end

# rails g migration AddDetailsToProducts part_number:string price:decimal will generate

# class AddDeatilsToproducts
class AddDetailsToProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :part_number, :string
    add_column :products, :price, :decimal
  end
end

# The migration generator will produce join tables if 'JoinTable' is part of the name.
rails g migration CreateJoinTableCustomerProduct customer product
# will produce the following migration:

# class CreateJoinTableCustomerProduct
class CreateJoinTableCustomerProduct < ActiveRecord::Migration[5.0]
  def change
    create_join_table :customers, :products do |t|
      # t.index [:customer_id, :product_id]
      # t.index [:product_id, :customer_id]
    end
  end
end

# 6.1.2 Sequencing

# A record of migrations that have already been run is kept in a special hidden data-base table that Rails maintains. 
# It is named schema_migrations and only has one column:

# mysql> desc schema_migrations;

# 6.1.3 The change Method
class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :code

      t.timestamps(6.1)
    end
  end
end

# 6.1.4 Rolling Back
# It is easy to roll back changes if you made a mistake in development.
rails db: rollback

# 6.1.5 Redo
# It is actually super common to forget to add something to a migration. Rails gives you
# rails db:migrate:redo

# 6.1.6 Reversible Operations
def change
  reversible do |dir|
    dir.up do
      execute <<-END
      CREATE FUNCTION add(integer, integer) RETURNS integer
        AS 'select $1 + $2;'
        LANGUAGE SQL
        IMMUTABLE
        RETURNS NULL ON NULL INPUT;
      END
    end
    dir.down do
      execute 'DROP FUNCTION add'
    end
  end
end

# 6.1.7 Irreversible Operations

def change
  reversible do |dir|
    dir.up do
      # Phone number fields are not integers, duh!
      change_column :clients, :phone, :string
    end
    dir.down { raise ActiveRecord::IrreversibleMigration }
  end
end

# 6.1.8 create_table(name, options, &block) Method

# how would you define a simple join table consisting of two foreign key columns and not needing its own primary key?
# Then use:

create_table :ingredients_recipes, id: false do |t|
  t.column :ingredient_id, :integer
  t.column :recipe_id, :integer
end

# If all you want to do is change the name of the primary key column from its default of id then,

create_table :clients, id: :clients_id do |t|
  t.column :name, :string
  t.column :code, :string
  t.column :created_at, :datetime
  t.column :updated_at, :datetime
end

# 6.1.9 change_table(table_name, &block) method
# This method works just like create_table and accepts the same kinds of column definitions.

# 6.1.10 create_join_table(*table_names) method
create_join_table :ingredients, :recipes

# :column_options Add any extra options to append to the foreign key column definitions.
# For example:

# class CreateJoinTableuserAuction
class CreateJoinTableUserAuction < ActiveRecord::Migration[5.0]
  def change
    create_join_table(:users, :auctions, column_options: { type: :uuid })
  end
end

# 6.1.11 API Reference
# This section details the methods that are available in the context of create_table and
# change_table methods within a migration class.

# 6.1.11.1 change(column_name, type, options = {})
# Changes the column’s definition according to the new options.
t.change(:name, :string, limit: 80)
t.change(:description, :text)

# 6.1.11.2 change_default(column_name, default)
# Sets a new default value for a column.
t.change_default(:qualification, 'new')
t.change_default(:authorized, 1)

# 6.1.11.3 column(column_name, type, options = {})
# Adds a new column to the named table.
t.column(:name, :string)

# 6.1.11.4 index(column_name, options = {})
# Adds a new index to the table.
# a simple index
t.index(:name)
# a unique index
t.index([:branch_id, :party_id], unique: true)
# a named index
t.index([:branch_id, :party_id], unique: true, name: 'by_branch_party')

# 6.1.11.5 belongs_to(*args) and references(*args)
# They add a foreign key column to another model, using Active Record naming conventions.
create_table :accounts do
  t.belongs_to(:person)
end

create_table :comments do
  t.references(:commentable, polymorphic: true)
end

# 6.1.11.6 remove(*column_names)
# Removes the column(s) specified from the table definition.
t.remove(:qualification)
t.remove(:qualification, :experience)

# 6.1.11.7 remove_index(options = {})
# Removes the given index from the table.

# remove the accounts_branch_id_index from the accounts table
t.remove_index column: :branch_id
# remove the accounts_branch_id_party_id_index from the accounts table
t.remove_index column: [:branch_id, :party_id]

# 6.1.11.8 remove_references(*args) and remove_belongs_to
# Removes a reference. Optionally removes a type column if marked as polymorphic.
t.remove_belongs_to(:person)
t.remove_references(:commentable, polymorphic: true)

# 6.1.11.9 remove_timestamps
# It removes created_at and updated_at columns.

# 6.1.11.10 rename(old_column_name, new_column_name)
# Renames a column.
t.rename :description, :name

# 6.1.11.11 revert
# The revert method can accept the name of a migration class, which when executed, reverts the given migration.
revert CreateProductsMigration

# 6.1.11.12 timestamps
# Adds Active Record–maintained timestamp ( created_at and updated_at ) columns to the table.
t.timestamps
