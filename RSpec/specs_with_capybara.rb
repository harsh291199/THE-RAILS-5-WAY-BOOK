# -------- Feature Specs with Capybara -----------

# Example:
feature "Some Awesome Feature" do
  background do
    # ...
  end

  scenario "A feature scenario" do
    # ...
  end
end

# ---- Capybara DSL ----

require 'rails_helper'

RSpec.feature 'Authentication' do
  let(:email) { 'bruce@wayneenterprises.com' }
  let(:password) { 'i4mb4tm4n!!!' }

  scenario "signs in with correct credentials" do
    create :user, email: email, password: password
    visit(new_user_session_path)
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Sign in'
    expect(response.status).to eq(302)
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content('Signed in successfully')
  end
  # ...
end

# ---- Capybara Drivers ----

Capybara.default_driver = :selenium

Capybara.javascript_driver = :poltergeist

scenario "JavaScript dependent scenario", js: true do
  # ...
end
