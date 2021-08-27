# frozen_string_literal: true

# Topic-6.3: Transactions

# Rails normally tries to execute your migration inside of a transaction, if that
# functionality is supported by your database. (Most do.) Occasionally, this can cause an
# issue if you try to do something that does not work inside of a transaction
# (like adding certain kinds of indexes 3 ).
# If you run into this kind of issue, you can turn off transactions for a particular
# migration using the disable_ddl_transaction! class method.

# class AddConcurrentIndexToBids
class AddConcurrentIndexToBids < ActiveRecord::Migration[5.0]
  disable_ddl_transaction!
  def change
    reversible do |dir|
      dir.up do
        execute "CREATE INDEX CONCURRENTLY index_auction_id
                 ON bids(auction_id)"
      end
      dir.down do
        execute 'DROP INDEX index_auction_id'
      end
    end
  end
end
