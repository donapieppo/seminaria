class HomePolicy < ApplicationPolicy
  def totem?
    true
  end

  def choose_organization?
    @user
  end

  def stats?
    @user.is_cesia?
  end
end

