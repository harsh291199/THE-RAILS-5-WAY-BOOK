# frozen_string_literal: true

# ---------------- Authentication with Warden --------------

# ------- Middleware ----------

env['warden'].authenticated?

env['warden'].authenticated?(:foo)

env['warden'].authenticated(:password)

env['warden'].authenticated!(:password)

env['warden'].authenticate(:password)
env['warden'].user

# ------- Strategies -----------

Warden::Strategies.add(:password) do
  def valid?
    params['username'] || params['password']
  end

  def authenticate!
    u = User.authenicate(params['username'], params['password'])
    u.nil? ? fail!('Could not log in') : success!(u)
  end
end

# ------- Scopes -------------

# Example:
class ImpersonationController < AdminController
  expose(:user)
  def create
    warden = request.env['warden']
    return unless warden.authenticated?(:admin)

    # sign out existing user
    warden.authenticated?(:user) && warden.logout(:user)
    # sign in user to impersonate
    warden.set_user(user, scope: :user)
    redirect_to root_path, notice: "Now impersonating #{user.name}"
  end
end


