# frozen_string_literal: true

# ------------ PostgreSQL ---------------

# --------- Array Type
class AddTagsToArticles < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.string :tags, array: true, length: 10
    end
  end
end

article = Article.create
# (0.1ms) BEGIN
# SQL (66.2ms) INSERT INTO "articles" ("created_at", "updated_at") VALUES
# ($1, $2) RETURNING "id" [["created_at", Wed, 23 Oct 2013 15:03:12

article.tags
# => ["rails", "ruby"]

# ---------- Querying

Article.where('? = ANY(tags)', 'rails')

# or
add_index :articles, :tags, using: 'gin'

# ---------- Network Address Types
class CreateNetworkAddresses < ActiveRecord::Migration
  def change
    create_table :network_addresses do |t|
      t.inet :inet_address
      t.cidr :cidr_address
      t.macaddr :mac_address
    end
  end
end

address = NetworkAddress.new
# => #<NetworkAddress id: nil, inet_address: nil, ...>

address.inet_address = 'abc'
# IPAddr::InvalidAddressError: invalid address

address.inet_address = '127.0.0.1'
# => "127.0.0.1"

address.save && address.reload

# --------------- UUID Type

add_column :table_name, :unique_identifier, :uuid

# -------------- Range Types

# Example:
class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.daterange :availability
    end
  end
end

room = Room.create(availability: Date.today..Float::INFINITY)
room.reload
room.availability # Tue, 22 Oct 2013...Infinity
room.availability.class # Range

# ------------ JSON Type

add_column :users, :preferences, :json

# ------------ Index Types

# PostgreSQL provides several index types: B-tree, Hash, GiST, SP-GiST, GIN and BRIN

# Example:
add_index :photos, :properties, using: :gin
add_index :photos, :properties, using: :gist # alternate
