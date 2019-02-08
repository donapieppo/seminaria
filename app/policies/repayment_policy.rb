class RepaymentPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  # manager
  # seminar owner
  # fund honer
  def show?
    @user and (@user.is_manager? or SeminarPolicy.new(@user, @record.seminar).update? or fund?)
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    @user and (@user.is_manager? or 
              ((! @record.notified) and SeminarPolicy.new(@user, @record.seminar).update?))
    # user_owns?(repayment.seminar) and ! repayment.notified 
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  #  fund owner
  def fund?
    @user and (@user.is_manager? or (@record.holder and @user == @record.holder))
  end

  def choose_fund?
    fund?
  end
end
