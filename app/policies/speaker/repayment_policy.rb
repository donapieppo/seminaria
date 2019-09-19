class Speaker::RepaymentPolicy < ApplicationPolicy
  # simple user can update until notified
  def update?
    @user and (@user.authorization.can_manage?(@record.seminar.organization_id) or 
              ((! @record.notified) and SeminarPolicy.new(@user, @record.seminar).update?))
  end

  def data_request?
    update? and (! @record.notified)
  end

  def submit_data_request?
    update? and (! @record.notified)
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
