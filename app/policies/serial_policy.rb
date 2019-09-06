class SerialPolicy < ApplicationPolicy
  def index?
    true 
  end

  def show?
    true
  end

  def create?
    @user and @user.authorization.can_manage?(@record.organization_id)
  end

  def update?
    create?
  end

  def destroy?
    update?
  end
end

