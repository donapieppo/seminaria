# frozen_string_literal: true

class Repayment::PrintComponent < ViewComponent::Base
  include DmUniboCommon::ApplicationHelper

  def initialize(repayment, current_user, ok_to_send: false)
    @repayment = repayment
    @current_user = current_user
    @ok_to_send = ok_to_send
  end

  def print_document_button(name, path)
    link_to dm_icon("print", text: name), path, class: "btn btn-sm btn-outline-primary"
  end

  def render?
    RepaymentPolicy.new(@current_user, @repayment).show?
  end
end
