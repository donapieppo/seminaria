class FundPolicy < ApplicationPolicy
  def show?
    owner_or_organization_manager?
  end

  # only manager
  def create?
    organization_manager?
  end

  # only manager
  def update?
    create?
  end

  def destroy?
    update?
  end
end
