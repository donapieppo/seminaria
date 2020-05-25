# FIXME
class RepaymentPolicy < ApplicationPolicy
  # can update seminar
  # user can read all organization (Greta)
  # fund owner
  def show?
    @user && (SeminarPolicy.new(@user, @record.seminar).update? || @user.authorization.can_read?(@record.seminar.organization_id) || @record.holder_id == @user.id)
  end

  # there's actually no create in controller. the new method (I know, :get and not a :post) acts like a create.
  # manager
  # can update seminar and is on time
  def create?
    (@user && (@user.authorization.can_manage?(@record.seminar.organization_id))) ||
    (@user && (! @record.seminar.too_late_for_repayment?) && SeminarPolicy.new(@user, @record.seminar).update?)
  end

  # manager
  # simple user can update until notified and in time if can update seminar
  def update?
    (@user && (@user.authorization.can_manage?(@record.seminar.organization_id))) ||
    (@user && (! @record.notified) && (! @record.seminar.too_late_for_repayment?) && SeminarPolicy.new(@user, @record.seminar).update?)
  end

  def destroy?
    update?
  end

  def notify?
    update?
  end

  # manager
  # fund owner
  def update_fund?
    @user && (@user.authorization.can_manage?(@record.seminar.organization_id) || (@record.holder_id == @user.id))
  end

  def update_bond?
    @user && @user.authorization.can_manage?(@record.seminar.organization_id)
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
end
