class UserPolicy < ApplicationPolicy
  # tutti possono provare a creare
  def new?
    @user
  end

  def create?
    @user && @user.current_organization && OrganizationPolicy.new(@user, @user.current_organization).manage?
  end
end

