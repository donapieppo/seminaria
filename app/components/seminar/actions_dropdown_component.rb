# frozen_string_literal: true

class Seminar::ActionsDropdownComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(seminar, current_user)
    @seminar = seminar
    @current_user = current_user
    @repayment = @seminar.repayment

    @seminar_policy = SeminarPolicy.new(@current_user, @seminar)

    @can_update_seminar = @seminar_policy.update?

    if @repayment
      @can_update_fund = RepaymentPolicy.new(@current_user, @repayment).update_fund?
    end
  end
end
