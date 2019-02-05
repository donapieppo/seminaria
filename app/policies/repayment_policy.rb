class RepaymentPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    @user.is_admin? or record.user_id == @user.id
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def mail_text?
    update?
  end

  def submit_mail_text?
    update?
  end
end
