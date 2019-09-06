class CurriculumVitaePolicy < DocumentPolicy
  def destroy?
    @user and RepaymentPolicy.new(@user, @record.repayment).update?
  end
end

