class HomePolicy < ApplicationPolicy
  def totem?
    true
  end

  def choose_organization?
    @user
  end
end

