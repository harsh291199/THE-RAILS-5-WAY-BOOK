# frozen_string_literal: true

# ---------------- has_secure_password -------------

# ------ Getting started --------
gem 'bcrypt', '~> 3.1.7'

# ------ Creating the Models --------
class User < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end

user = User.create(email: 'user@example.com', password: 'therails4way',
                   password_confirmation: 'therails4way')

user.authenticate('therails4way')

# ------ Setting Up the Controllers --------

rails generate controller users

# Application Controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  protected

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end

# Sessions Controller
class SessionsController < ApplicationController
  def new; end

  def create
    user = User.where(email: params[:email]).first

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Signed in successfully.'
    else
      flash.now.alert = 'Invalid email or password.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out successfully.'
  end
end

# -------- Controller, Limiting Access to Actions -------

# Example:
class ApplicationController < ActionController::Base
  # ...

  protected

  def authenticate
    return if current_user

    redirect_to new_session_url, alert: 'You need to sign in or sign up before continuing.'
  end
end

class DashboardController < ApplicationController
  before_action :authenticate
end
