# -------- RSpec and Rails -----------

# ---- Model Specs ----

# Schedule model
class Schedule < ActiveRecord::Base
  has_many :days
end

require 'spec_helper'

describe Schedule do
  let(:schedule) { Schedule.new }
  
  it "should calculate total hours" do
    days = double('days')
    expect(days).to receive(:sum).with(:hours).and_return(40)
    allow(schedule).to receive(:days).and_return(days)
    expect(schedule.total_hours).to eq(40)
  end
end

# ---- Routing Specs ----

context "Messages routing" do
  it "routes /messages/ to messages#show" do
    expect(get: "/messages").to route_to(
      controller: "articles",
      action: "index"
    )
  end

  it "does not route an update action" do
    expect(post: "/messages").to_not be_routable
  end
end

# ---- Controller Specs ----
RSpec.describe MessagesController, type: :controller do
  let(:user) { create(:user) }

  before(:each) do
    sign_in(user)
  end
end

config.include Devise::Test::ControllerHelpers, type: :controller

# ---Writing Examples
it "is successful" do
  get :index
  expect(response.status).to eq(200)
end

describe "accepting" do
  let(:scheduled_at) { 2.days.from_now }

  it "a proposed time" do
    post :accept, params: { id: call_request.id, scheduled_at: scheduled_at.to_s }
  end
end

# ---Specifying Errors
it "raises an error" do
  bypass_rescue
  expect { get :index }.to raise_error(AccessDenied)
end

# ---- View Specs ----
require 'rails_helper'

RSpec.describe "messages/show.html.haml", type: :view do
  pending "add some examples to (or delete) #{ FILE }"
end

# Assigning Variables
assign(:message, @message)

# Rendering
it "displays the message subject" do
  render
  expect(rendered).to contain('RSpec rocks!')
end

# ---- Helper Specs ----
RSpec.describe ApplicationHelper, :type => :helper do
  describe "#page_title" do
    it "returns the instance variable" do
      assign(:title, "My Title")
      expect(helper.page_title).to eql("My Title")
    end
  end
end
