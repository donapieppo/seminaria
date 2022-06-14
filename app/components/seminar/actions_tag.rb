# frozen_string_literal: true

class Seminar::ActionsTag < ViewComponent::Base
  def initialize(seminar, current_user)
    @seminar = seminar
    @current_user = current_user
    @repayment = @seminar.repayment

    @seminar_policy = SeminarPolicy.new(@current_user, @seminar)
    @repayment_policy = RepaymentPolicy.new(@current_user, @repayment)

    @can_update_seminar = @seminar_policy.update? 
    @can_update_fund    = @repayment ? @repayment_policy.update_fund? : false
  end
end


