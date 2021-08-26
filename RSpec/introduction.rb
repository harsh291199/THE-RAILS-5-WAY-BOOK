# -------- RSpec ---------------

# Example

require 'rails_helper'

describe Timesheet, type: :model do
  let(:timesheet) { build(:timesheet) }

  describe "hours worked" do
    it "expects a number" do
      timesheet.hours_worked = 'abc'
      expect(timesheet.error_on(:hours_worked).size).to eq(1)  
    end
  end

  context "when submitted" do
    it "sends an email notification to the manager" do
      expect(Notifier).to receive(:send_later).
      with(:deliver_timesheet_submitted, timesheet)
      timesheet.submit
    end
  end 
end

# ------- Behavior-Driven Development

require 'rails_helper'

feature "Search Documents" do
  let(:user) { create(:user, name: 'Joe') }

  let(:published_doc) do
    create(:document, title: 'Global Equities 2016', status: 'published')
  end

  let(:private_doc) do
    create(:document, title: 'Global Equities 2017', status: 'draft')
  end

  background { login_as user }

  scenario "takes you to the search results page" do
    search_for("Global")
    expect(current_path).to include(search_results_path)
  end

  scenario "doesn't return draft docs" do
    search_for("Global")
    expect(page).to_not have_content(private_doc.title)
  end

  def search_for(term)
    visit search_path
    fill_in 'Search', with: term
    click_button 'Search'
  end
end
