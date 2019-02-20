class RepaymentPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?(o)
    @user.can_manage?(o)
  end

  # manager
  # seminar owner
  # fund honer
  def show?
    @user and (SeminarPolicy.new(@user, @record.seminar).update? or update_fund?)
  end

  def new?
    @user and SeminarPolicy.new(@user, @record.seminar).update?
  end

  def create?
    true
  end

  def update?
    @user and (@user.can_manage?(@record.seminar.organization_id) or 
              ((! @record.notified) and SeminarPolicy.new(@user, @record.seminar).update?))
    # user_owns?(repayment.seminar) and ! repayment.notified 
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def notify?
    update?
  end

  #  fund owner
  def update_fund?
    @user and (@user.can_manage?(@record.seminar.organization_id) or (@record.holder and @user == @record.holder))
  end

  def choose_fund?
    update_fund?
  end

  def print_letter?
    show?
  end

  def print_decree?
    show?
  end

  def print_proposal?
    show?
  end
end
