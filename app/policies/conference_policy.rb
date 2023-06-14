class ConferencePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  # every user can create a cycle in current_organization
  # FIXME
  def create?
    @user
  end

  def update?
    owner_or_record_organization_manager?
  end

  def destroy?
    update?
  end
end
