class PlacePolicy < ApplicationPolicy
  def index?
    true 
  end

  def show?
    true
  end

  def create?
    organization_manager?
  end

  def update?
    organization_manager?
  end

  def destroy?
    update?
  end
end

