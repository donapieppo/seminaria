class Speaker::RepaymentPolicy < ApplicationPolicy
  # simple user can update until notified
  def update?
    (@user && @user.authorization.can_manage?(@record.seminar.organization_id)) ||
      (@user && !@record.notified && SeminarPolicy.new(@user, @record.seminar).update?)
  end

  def data_request?
    update? && !@record.notified
    true
  end

  def submit_data_request?
    update? && !@record.notified
  end

  # skip_before_action :redirect_unsigned_user, only: [:accept, :show, :edit, :update]

  def show?
    true
  end

  def accept?
    true
  end

  def edit?
    true
  end

  def update?
    true
  end
end
