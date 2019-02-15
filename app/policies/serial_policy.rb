class SerialPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true 
  end

  def show?
    true
  end

  def create?
    @user and @user.can_manage?(@record.organization_id)
  end

  def new?
    create?
  end

  def update?
    @user and (@user.can_manage?(@record.organization_id) or record.user_id == @user.id)
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

end

