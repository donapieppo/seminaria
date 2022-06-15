class RepaymentPolicy < ApplicationPolicy
  def can_manage_organization?
    @user && @user.authorization.can_manage?(@record.seminar.organization_id)
  end

  def can_update_seminar?
    @user && SeminarPolicy.new(@user, @record.seminar).update?
  end

  def not_too_late?
    ! @record.seminar.too_late_for_repayment?
  end

  # index? - see controller authorize current_organization, :manage?
  
  # can update seminar
  # user can read all organization (Greta)
  # fund owner
  def show?
    @user && (can_update_seminar? || @record.holder_id == @user.id || @user.authorization.can_read?(@record.seminar.organization_id))
  end

  def create?
    can_manage_organization? || (can_update_seminar? && not_too_late?)
  end

  def update?
    can_manage_organization? || (can_update_seminar? && (! @record.notified) && not_too_late?)
  end

  def destroy?
    can_manage_organization? || (can_update_seminar? && (! @record.notified))
  end

  # FIXME controlled only in view (ok_to_send)
  def notify?
    update?
  end

  def update_fund?
    can_manage_organization? || (@user && (@record.holder_id == @user.id) && not_too_late?)
  end

  def update_bond?
    can_manage_organization?
  end

  def choose_fund?
    update_fund?
  end

  def print_request?
    show?
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

  def print_regularity?
    show?
  end
end
