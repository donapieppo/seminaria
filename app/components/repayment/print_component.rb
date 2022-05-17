# frozen_string_literal: true

class Repayment::PrintComponent < ViewComponent::Base
  def initialize(repayment, current_user,  ok_to_send: false)
    @repayment = repayment
    @current_user = current_user
    @ok_to_send = ok_to_send
  end

  def render?
    RepaymentPolicy.new(@current_user, @repayment).show?
  end
end
