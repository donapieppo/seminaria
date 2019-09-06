class DocumentPolicy < ApplicationPolicy
  def create?
    @user and SeminarPolicy.new(@user, @record.seminar || @record.repayment.seminar).update?
  end
end
