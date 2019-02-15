class OrganizationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
    @current_authlevel = nil
  end

  def manage?
    @user and @user.can_manage?(@record)
  end

  def admin?
    @user and @user.can_admin?(@record)
  end
end
