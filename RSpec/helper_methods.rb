# -------- Helper Methods ---------------

# spec/support/helpers.rb
module Helpers
  def help
    :available
  end
end

# You can include this module in all example groups like this:
RSpec.configure do |c|
  c.include Helpers
end

RSpec.describe "an example group" do
  it "has access to the helper methods defined in the module" do
    expect(help).to be(:available)
  end
end

# Using config.extend
RSpec.configure do |c|
  c.extend Helpers
end

Spec.describe "an example group" do
  puts "Help is #{help}"

