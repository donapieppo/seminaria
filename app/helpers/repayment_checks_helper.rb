module RepaymentChecksHelper
  def checked_icon(ok)
    if ok
      '<span class="float-right"><i class="fas fa-check-circle mr-3" style="font-size: 24px; color: green"></i></span>'.html_safe
    else
      '<span class="float-right"><i class="fas fa-exclamation-circle mr-3" style="font-size: 24px; color: red"></i></span>'.html_safe
    end
  end

  def checked_title(repayment, what)
    checked_icon(repayment_correct_data_group?(repayment, what)) + " " + I18n.t(what)
  end

  def attribute_to_s(a)
    a.blank? ? ' - ' : a
  end

  def repayment_correct_data_group?(repayment, what)
    case what
    when :reason
      repayment_speaker_reason_ok?(repayment)
    when :seminar_reason
      repayment_seminar_reason_ok?(repayment)
    when :fund
      if (repayment.holder_id == repayment.seminar.user_id) or user_is_manager?
        (repayment.holder_id and repayment.fund_id)
      else
        repayment.holder_id
      end
    when :compensation
      ! repayment_missing_payment_and_refund?(repayment)
    when :speaker_details
      repayment_speaker_anagrafica_ok?(repayment) and repayment_speaker_address_ok?(repayment) and repayment_speaker_role_ok?(repayment)
    else
      false
    end
  end

  def repayment_holder_ok?(repayment)
    repayment.holder_id
  end

  def repayment_speaker_reason_ok?(repayment)
    ! ((repayment.documents.empty?) || (repayment.reason.blank?))
  end

  def repayment_seminar_reason_ok?(repayment)
    ! ((repayment.activity_details.blank?) || (repayment.scientific_interests.blank?))
  end

  def repayment_speaker_anagrafica_ok?(repayment)
    ! ((repayment.name.blank?) || (repayment.surname.blank?) || (repayment.birth_place.blank?) || (repayment.birth_date.blank?))
  end

  def repayment_speaker_role_ok?(repayment)
    ! ((repayment.affiliation.blank?) || (repayment.position_id.nil?) || (repayment.email.blank?))
  end

  def repayment_speaker_address_ok?(repayment)
    ! ((repayment.address.blank?) || (repayment.postalcode.blank?) || (repayment.city.blank?))
  end

  def repayment_missing_payment_and_refund?(repayment)
    ! ((repayment.payment.to_i > 0) || (repayment.expected_refund.to_i > 0))
  end

  def repayment_all_ok_to_send?(repayment)
    repayment_holder_ok?(repayment) && 
    repayment_speaker_reason_ok?(repayment) && 
    repayment_speaker_anagrafica_ok?(repayment) && 
    repayment_speaker_role_ok?(repayment) && 
    repayment_speaker_address_ok?(repayment) 
  end
end

