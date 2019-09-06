class SerialPolicy < ApplicationPolicy
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
    create?
  end

  def destroy?
    update?
  end
end

