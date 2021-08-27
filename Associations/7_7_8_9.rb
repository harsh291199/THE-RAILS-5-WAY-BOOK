# frozen_string_literal: true

# ------------------ 7.7 Working with Unsaved Objects and Associations -----------------

# ---------------- 7.7.1 One-to-One Associations -------------------------
# Assigning an object to a has_one association automatically saves that object
# (and potentially the object being replaced, if there is one) so that their
# foreign key fields are updated.

# ---------------- 7.7.2 Collections --------------------------------
# Adding a new object to has_many and has_and_belongs_to_many collections
# cautomatically saves it, unless the owner of the collection is not yet stored in the
# database (since there would be no foreign key value to save).

# ----------------- 7.7.3 Deletion ----------------------------------
class User < ActiveRecord::Base
  has_many :timesheets, autosave: true
end

user = User.where(name: 'Durran')
user.timesheets.closed.each(&:mark_for_destruction)
user.save # => closed timesheets get automatically deleted

# ------------------------ 7.8 Association Extensions ----------------------------------

# An association extension on a people collection
class Account < ActiveRecord::Base
  has_many :people do
    def named(full_name)
      first_name, last_name = full_name.split(' ', 2)
      where(first_name: first_name, last_name: last_name).first_or_create
    end
  end
end

account = Account.first
person = account.people.named('David Heinemeier Hansson')
person.first_name # => "David"
person.last_name # => "Heinemeier Hansson"

# If you need to share the same set of extensions between many associations,
# you can specify an extension module
module ByNameExtension
  def named(full_name)
    first_name, last_name = full_name.split(' ', 2)
    where(first_name: first_name, last_name: last_name).first_or_create
  end
end

class Account < ActiveRecord::Base
  has_many :people, -> { extending(ByNameExtension) }
end

class Company < ActiveRecord::Base
  has_many :people, -> { extending(ByNameExtension) }
end

# -------------------------- 7.9 The CollectionProxy Class ------------------------------

# ---------------- 7.9.1 Owner, Reflection, and Target ------------------------

# The object that holds the association is known as the @owner.
# The associated object (or array of objects) is known as the @target.
# Metadata about the association itself is available in @reflection.

# class ArticleCategory
class ArticleCategory < ActiveRecord::Base
  has_ancestry
  has_many :articles do
    def published_prior_to(date, options = {})
      if owner.is_root?
        Article.where('published_at < ? and category_id = ?', date, proxy_owner)
      else
        # self is the 'articles' association here so we inherit its scope
        all(options)
      end
    end
  end
end

# ------------------- 7.9.2 reload and reset -----------------------------

# The reset method puts the association proxy back in its initial state,
# which is unloaded (cached association objects are cleared).

# The reload method invokes reset and then loads associated objects from the database.
