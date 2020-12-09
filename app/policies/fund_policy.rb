class FundPolicy < ApplicationPolicy
  # The list of all funds
  def show?
    owner_or_record_organization_manager?
  end

  # only manager
  def create?
    record_organization_manager?
  end

  # only manager
  def update?
    create?
  end

  def destroy?
    update?
  end
end
