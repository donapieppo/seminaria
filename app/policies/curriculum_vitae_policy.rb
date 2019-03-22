class CurriculumVitaePolicy < DocumentPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def destroy?
    @user and RepaymentPolicy.new(@user, @record.repayment).update?
  end
end

