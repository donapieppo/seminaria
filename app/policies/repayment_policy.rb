class RepaymentPolicy < ApplicationPolicy
  def index?
    @user and @user.current_organization and OrganizationPolicy.new(@user, @user.current_organization).read?
  end

  # manager
  # seminar owner
  # fund honer
  def show?
    @user and (SeminarPolicy.new(@user, @record.seminar).update? or @user.authorization.can_read?(@record.seminar.organization_id) or (@record.holder and @user == @record.holder))
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
    @user and (@user.authorization.can_manage?(@record.seminar.organization_id) or 
              ((! @record.notified) and SeminarPolicy.new(@user, @record.seminar).update?))
  end

  def destroy?
    update?
  end

  def notify?
    update?
  end

  # fund owner
  def update_fund?
    @user and (@user.authorization.can_manage?(@record.seminar.organization_id) or (@record.holder and @user == @record.holder))
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

  def print_repayment?
    show?
  end

  def print_refund?
    show?
  end

  def print_other?
    show?
  end

  def data_request?
    update? and (! @record.notified)
  end

  def submit_data_request?
    update? and (! @record.notified)
  end
end
