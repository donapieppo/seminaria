class PlacePolicy < ApplicationPolicy
  def index?
    true 
  end

  def create?
    @user and @user.authorization.can_manage?(@record.organization_id) 
  end

  def update?
    @user and @user.authorization.can_manage?(@record.organization_id) 
  end

  def destroy?
    update?
  end
end

