class OrganizationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def manage?
    @user.can_manage?(@record)
  end
end
