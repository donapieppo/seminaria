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
    owner_or_record_organization_manager?
  end

  # FIXME li cancella solo manager o se non e' ancora stata inviata
  def destroy?
    record_organization_manager? || (owner? && ! @record.repayment)
  end

  def mail_text?
    update?
  end

  def submit_mail_text?
    update?
  end
end
