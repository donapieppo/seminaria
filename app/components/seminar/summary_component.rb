# frozen_string_literal: true

class Seminar::SummaryComponent < ViewComponent::Base
  def initialize(seminar, with_repayment: false)
    @seminar = seminar
    @with_repayment = with_repayment
    @repayment = @seminar.repayment
  end
end



