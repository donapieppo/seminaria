class HomePolicy < ApplicationPolicy
  def totem?
    true
  end

  def choose_organization?
    true
  end
end

