# frozen_string_literal: true

# ---------------- pundit  -------------

# ------- Getting started -------
rails generate pundit: install

# Example:
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end

# Application Controller
class ApplicationController < ActionController::Base
  include Pundit
end

# ------- Creating a Policy ---------

# rails generate pundit:policy post

class PostPolicy < ApplicationPolicy
  Scope = Struct.new(:user, :scope) do
    def resolve
      scope
    end
  end
end

class PostPolicy < ApplicationPolicy
  def create?
    user.admin?
  end
  # ...
end

class PostPolicy < ApplicationPolicy
  def destroy?
    user.admin? && !record.published?
  end
  # ...
end

# ------ Controller Integration ------

# Example:
class PostsController < ApplicationController
  expose(:post)
  def create
    authorize post
    post.save
    respond_with(post)
  end
  # ...
end

class ApplicationController < ActionController::Base
  after_filter :verify_authorized, except: :index
end

# ------ Policy Scopes ------

class PostPolicy < ApplicationPolicy
  Scope = Struct.new(:user, :scope) do
    def resolve
      if user.admin?
        scope
      else
        scope.where(published: true)
      end
    end
  end
  # ...
end

class ApplicationController < ActionController::Base
  after_filter :verify_policy_scoped, only: :index
end

# ------- Strong Parameters -----------

class AssignmentPolicy < ApplicationPolicy
  def permitted_attributes
    if user.admin?
      %i[title question answer status]
    else
      [:answer]
    end
  end
end

# ------- Testing policies -----------

# spec/support/matchers/permit_matcher.rb
RSpec::Matchers.define :permit do |action|
  match do |policy|
    policy.public_send("#{action}?")
  end

  failure_message do |policy|
    "#{policy.class} does not permit #{action} on #{policy.record} for
    #{policy.user.inspect}."
  end

  failure_message_when_negated do |policy|
    "#{policy.class} does not forbid #{action} on #{policy.record} for
    #{policy.user.inspect}."
  end
end

# spec/policies/post_policy.rb
require 'spec_helper'

describe PostPolicy do
  subject(:policy) { PostPolicy.new(user, post) }

  let(:post) { FactoryGirl.build_stubbed(:post) }
  context 'for a visitor' do
    let(:user) { nil }
    it { is_expected.to permit(:show) }
    it { is_expected.to_not permit(:create) }
    it { is_expected.to_not permit(:new) }
    it { is_expected.to_not permit(:update) }
    it { is_expected.to_not permit(:edit) }
    it { is_expected.to_not permit(:destroy) }
  end

  context 'for an administrator' do
    let(:user) { FactoryGirl.create(:administrator) }
    it { is_expected.to permit(:show) }
    it { is_expected.to_not permit(:create) }
    it { is_expected.to_not permit(:new) }
    it { is_expected.to_not permit(:update) }
    it { is_expected.to_not permit(:edit) }
    it { is_expected.to_not permit(:destroy) }
  end
end
