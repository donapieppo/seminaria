class SeminarPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true 
  end

  def archive?
    index?
  end

  def show?
    true
  end

  def choose_type
    @user
  end

  def new?
    @user
  end

  def create?
    true
  end

  def update?
    @user and (@user.can_manage?(@record.organization_id) or record.user_id == @user.id)
  end

  def edit?
    update?
  end

  # FIXME li cancella solo manager o se non e' ancora stata inviata
  def destroy?
    @user and (@user.can_manage?(@record.organization_id) or (@user.owns?(record) and ! record.repayment))
  end

  def mail_text?
    update?
  end

  def submit_mail_text?
    update?
  end
end
