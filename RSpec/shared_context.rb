# -------- Shared context ---------------

# spec/support/authenticated_user.rb
RSpec.shared_context 'authenticated user' do
  let(:current_user) { create(:user) }

  before do
    sign_in current_user
  end
end

# For include a shared context
context "user is authenticated" do
  include_context 'authenticated user'
  # ...
end