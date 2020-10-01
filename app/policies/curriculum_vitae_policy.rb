class CurriculumVitaePolicy < DocumentPolicy
  def destroy?
    @user && RepaymentPolicy.new(@user, @record.repayment).update?
  end
end

