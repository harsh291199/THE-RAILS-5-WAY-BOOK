# -------- Factory Girl -----------

# --- Setup ---
gem 'factory_girl_rails'

# In rails_helper.rb
config.include FactoryGirl::Syntax::Methods

# --- Factory Definitions ---
FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Doe"
    admin false
  end

  factory :admin, class: User do
    first_name "Admin"
    last_name "User"
    admin true
  end
end

# With using inheritance
FactoryGirl.define do
  factory :user do
    name "John Doe"
    admin false
  
    factory :admin do
      name "Admin"
      admin true
    end
  end
end

# --- Usage ---
user = build(:user)
user = create(:user)
attrs = attributes_for(:user)
stub = build_stubbed(:user)

create(:user) do |user|
  user.posts.create(attributes_for(:post))
end

# --- Dynamic Attributes ---
factory :user do
  first_name "John"
  last_name "Doe"
  activation_code { User.generate_activation_code }
  date_of_birth
  { 21.years.ago }
end

# --- Dependent Attributes ---
factory :user do
  first_name "Joe"
  last_name "Blow"
  email { "#{first_name}.#{last_name}@example.com".downcase }
end

# --- Associations ---

factory :post do
  author
end

factory :post do
  association :author, factory: :user, last_name: "Writely"
end

# has_many relationship
FactoryGirl.define do
  factory :post do
    title "Through the Looking Glass"
    user
  end

  factory :user do
    name "John Doe"
    factory :user_with_posts do
      transient do
        posts_count 5
      end
    end
  end
end

# --- Sequences ---
FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

factory :user do
  sequence(:email) { |n| "person#{n}@example.com" }
end

# --- Traits ---
factory :story do
  title "My awesome story"
  author

  trait :published do
    published true
  end

  trait :unpublished do
    published false
  end
  
  trait :week_long_publishing do
    start_at { 1.week.ago }
    end_at { Time.now }
  end

  trait :month_long_publishing do
    start_at { 1.month.ago }
    end_at { Time.now }
  end

  factory :week_long_published_story,
    traits: [:published, :week_long_publishing]

  factory :month_long_published_story,
    traits: [:published, :month_long_publishing]

  factory :week_long_unpublished_story,
    traits: [:unpublished, :week_long_publishing]

  factory :month_long_unpublished_story,
    traits: [:unpublished, :month_long_publishing]
end

# Traits can be used as attributes:

factory :week_long_published_story_with_title, parent: :story do
  published
  week_long_publishing
  title { "Publishing that was started at #{start_at}" }
end

# --- Callbacks ---

# after(:build), after(:create)
factory :user do
  after(:build) { |user| do_something_to(user) }
  after(:create) { |user| do_something_else_to(user) }
end

# before(:create)
factory :user do
  callback(:after_stub, :before_create) { do_something }
  after(:stub, :create) { do_something_else }
  before(:create, :custom) { do_a_third_thing }
end
