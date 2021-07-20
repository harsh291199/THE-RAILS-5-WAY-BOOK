# frozen_string_literal: true

# Topic-6.4: Data Migration

# 6.4.1 Using SQL
# In most cases, you should craft your data migration in raw SQL using the execute
# command that is available inside a migration class.

# Example:
# class CombineNumerInPhones
class CombineNumberInPhones < ActiveRecord::Migration
  def change
    add_column :phones, :number, :string
    reversible do |dir|
      dir.up do
        execute "UPDATE phones SET number =
    CONCAT(area_code, prefix, suffix)"
      end
      dir.down do
        # code to undo that update, ugh...
        # might want to make this one Irreversible
      end
    end

    remove_column :phones, :area_code
    remove_column :phones, :prefix
    remove_column :phones, :suffix
  end
end

# better Ruby-based solution would be to use Active Record’s update_ all method.
Phone.update_all('set number = concat(area_code, prefix, suffix)')

# 6.4.2 Migration Models
# If you declare an Active Record model inside of a migration script, it’ll be name-
# spaced to that migration class.

# class HashPasswordOnUsers
class HashPasswordsOnUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def change
    reversible do |dir|
      dir.up do
        add_column :users, :hashed_password, :string
        User.reset_column_information
        User.find_each do |user|
          user.hashed_password = Digest::SHA1.hexdigest(user.password)
          user.save!
        end
        remove_column :users, :password
      end
      dir.down { raise ActiveRecord::IrreversibleMigration }
    end
  end
end

# 6.4.3 Database Adapter Helper Methods

# 6.4.3.1 select_all(sql)
select_all('SELECT * FROM users').to_a

# 6.4.3.2 select_rows(sql)
select_rows('SELECT id, name FROM users')

# 6.4.3.3 select_one(sql)
# Similar to select_all, but returns one row as a hash

# 6.4.3.4 select_values(sql)
select_values('SELECT * FROM users')

# 6.4.3.5 select_value(sql)
# Similar to select_values , but returns only the first value as a string.
select_value('SELECT answer FROM secret(life, universe, everything)')
