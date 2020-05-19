class ZoomPolicy < ApplicationPolicy

  def show?
    true
  end

  def user?
    true
  end

  def create?
    true
  end

  def oauth?
    true
  end
end
