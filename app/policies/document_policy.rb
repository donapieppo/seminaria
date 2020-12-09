class DocumentPolicy < ApplicationPolicy
  # owner of realative seminar (for cv cv.repayment.seminar)
  def create?
    @user and SeminarPolicy.new(@user, @record.seminar || @record.repayment.seminar).update?
  end

  def destroy?
    create?
  end
end
