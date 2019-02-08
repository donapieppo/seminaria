class FundPolicy
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

  def new?
    @user.is_manager?
  end

  def create?
    @user.is_manager?
  end

  def update?
    @user.is_manager?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
