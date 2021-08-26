# -------- Basic syntax and API ---------------

# ---- Contexts (aka Example Groups)

describe Timesheet, type: :model do

# ----- Shared Variables

describe BlogPost do
  before do
    @blog_post = BlogPost.new title: 'Hello'
  end
  
  it "does something" do
    expect(@blog_post).to ...
  end
  
  it "does something else" do
    expect(@blog_post).to ...
  end
end

# ---- Examples ----

# --- specify
describe BlogPost do
  context "upon creation" do
    let(:blog_post) { create(:blog_post) }
    specify { expect(blog_post).to_not be_published }
  end
end

# --- pending
describe GeneralController do
  describe "on GET to index" do
    it "is successful" do
      pending("not implemented yet")
    end
  end
end

# ---- Expectations ----
expect(receiver).to eq(expected)
expect(receiver).to match(regexp)

# ---- Metadata ----
RSpec.describe "a group with user-defined metadata", :basic, :foo => 17 do
  it 'has access to the metadata in the example' do |example|
    expect(example.metadata[:basic]).to be_true
    expect(example.metadata[:foo]).to eq(17)
  end

# ---- Hooks ----
class Database
  def self.transaction
    puts "open transaction"
    yield
    puts "close transaction"
  end
end

RSpec.describe "around filter" do
  around(:example) do |example|
    Database.transaction(&example)
  end

  it "gets passed as a proc" do
    puts "run the example"
  end
end

# ---- Implicit Subject ----
describe BlogPost do
  it { is_expected.to be_invalid }
end

# ---- Explicit Subject ----
describe BlogPost do
  subject { BlogPost.new(title: 'foo', body: 'bar') }
  it { is_expected.to be_valid }
end
