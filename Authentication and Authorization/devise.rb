# frozen_string_literal: true

# ---------------- Authentication with Devise --------------

# ----- Getting started -----

rails generate devise: install

# ------ Models --------

# authentication in model
rails generate devise User

# Databse migration looks like
class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :remember_created_at

      t.integer :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_i

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end

# User model
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end

# ------ Controllers --------

# Example:
class MeatProcessorController < ApplicationController
  before_action :authenticate_user!
end

# ------ Routing --------

devise_for :users

devise_for :admins, controllers: { sessions: 'admin/sessions' }

# ----- Post Sign-in options
get '/users' => 'users#index', as: :user_root # creates user_root_path
namespace :user do
  root 'users#index' # creates user_root_path
end

# ----- Testing with Devise -------

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end

# ------ Strong Parameters ---------

# Example:
class ApplicationController < ActionController::Base
  before_action :devise_permitted_parameters, if: :devise_controller?

  protected

  def devise_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :phone_number
  end
end

# ------ Views ---------

config.scoped_views = true
