class RepaymentPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false # we use authorize current_organization, :manage? in index
  end

  # manager
  # seminar owner
  # fund honer
  def show?
    @user and (SeminarPolicy.new(@user, @record.seminar).update? or update_fund?)
  end

  # in controller we check data restrains
  def new?
    @user and SeminarPolicy.new(@user, @record.seminar).update?
  end

  # there's actually no create in controller. the new method (I know, :get and not a :post) acts like a create.
  def create?
    new?
  end

  # simple user can update until notified
  def update?
    @user and (@user.can_manage?(@record.seminar.organization_id) or 
              ((! @record.notified) and SeminarPolicy.new(@user, @record.seminar).update?))
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

  # fund owner
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
