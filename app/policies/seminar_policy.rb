class SeminarPolicy < ApplicationPolicy
  def index?
    true 
  end

  def archive?
    index?
  end

  def show?
    true
  end

  def choose_type?
    @user
  end

  def new?
    @user
  end

  def create?
    true
  end

  def update?
    @user and (@user.authorization.can_manage?(@record.organization_id) or @record.user_id == @user.id)
  end

  # FIXME li cancella solo manager o se non e' ancora stata inviata
  def destroy?
    @user and (@user.authorization.can_manage?(@record.organization_id) or (@user.owns?(@record) and ! @record.repayment))
  end

  def mail_text?
    update?
  end

  def submit_mail_text?
    update?
  end
end
