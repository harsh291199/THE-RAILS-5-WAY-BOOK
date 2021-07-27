# frozen_string_literal: true

# ------------ Attributes API ---------------

# Attribute API Syntax
attribute(name, cast_type, options)

# db/schema.rb
create_table :movie_tickets, force: true do |t|
  t.float :price
end

# without attribute API
class MovieTicket < ActiveRecord::Base
end

movie_ticket = MovieTicket.new(price: 145.40)
movie_ticket.save!

movie_ticket.price # => Float(145.40)

# with attribute API
class MovieTicket < ActiveRecord::Base
  attribute :price, :integer
end

movie_ticket.price # => 145

# -------- Custom Types

# Example:
class MovieRating < ActiveRecord::Base
  TOTAL_STARS = 5

  before_save :convert_percent_rating_to_stars

  def convert_percent_rating_to_stars
    rating_in_percentage = value.gsub(/%/, '').to_f

    self.rating = (rating_in_percentage * TOTAL_STARS) / 100
  end
end

# --------------- Registering New Attribute Types

# config/initializers/custom_attribute_types.rb
ActiveRecord::Type.register :inquiry, Inquiry.new

# ------------ Serialized Attributes ---------------

# Example: serialize method
class StarRatingType < ActiveRecord::Type::Integer
  TOTAL_STARS = 5

  def serialize(value)
    if value.present? && !value.is_a?(Integer)
      rating_in_percentage = value.gsub(/%/, '').to_i

      star_rating = (rating_in_percentage * TOTAL_STARS) / 100
      super(star_rating)
    else
      super
    end
  end
end

movie_rating = MovieRating.new(rating: '25.6%')
movie_rating.save!

movie_rating.rating # => 1

# Querying with rating in percentage 25.6%
MovieRating.where(rating: '25.6%')

# => #<ActiveRecord::Relation [#<MovieRating id: 1000, rating: 1 ... >]>
