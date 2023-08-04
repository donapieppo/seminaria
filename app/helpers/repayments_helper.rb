module RepaymentsHelper
  # compenso senza rimborso spese
  def _payment_string(repayment, lang)
    if lang == "it"
      "Per il presente incarico è previsto un compenso lordo percipiente pari a #{euro(repayment.lordo_percipiente)}. " \
      "Il compenso sarà assoggettato alle ritenute previste in termini di legge e verrà corrisposto dopo la conclusione " \
      "dell’incarico in subordine alla regolare esecuzione di quest’ultimo." \
      "Il prestatore si impegna a conservare e presentare al termine dell’incarico i documenti giustificativi comprovanti " \
      "il sostenimento delle spese necessarie allo svolgimento dell’attività, unitamente alla nota spese."
    else
      "The service to be provided by Prof. #{repayment.seminar.speaker} is considered an occasional working activity and it will be " \
      "regulated as an employment contract pursuant to article 67, paragraph 1, letter L) of Presidential Decree 917/86. " \
      "For this assignment, a gross remuneration of #{euro(repayment.lordo_percipiente)} is envisaged, subject to the withholdings " \
      "established by law. " \
      "The payment will be done at the end of the activity and it will be subject to verification of regular execution by the " \
      "Department Administration. The payment will be also subject to receipt of the Bill of Costs duly filled with costs incurred " \
      "for the implementation of the activity and signed by Prof. #{repayment.seminar.speaker}, " \
      "together with a scanned copy of the supporting documents, which shall be delivered to the Department Administrative Offices."
    end
  end

  # rimborso spese
  def _refund_string(repayment, lang)
    if lang == "it"
      "Per il presente incarico a titolo gratuito non è previsto alcun compenso ma il mero rimborso delle spese strettamente necessarie " \
      "risultanti dai documenti giustificativi visionati e trattenuti in originale dall’Ufficio Amministrazione fino ad un importo massimo " \
      "di #{euro(repayment.expected_refund)}. I documenti giustificativi comprovanti il sostenimento delle spese possono essere rimborsati entro " \
      "i massimali ed in conformità alla disciplina di cui al Regolamento Missioni dell’Università. " \
      "Il rimborso spese non è assoggettato ad alcuna ritenuta, verrà corrisposto previa presentazione di nota spese al termine dell’incontro " \
      "ed è subordinato alla regolare esecuzione di quest’ultimo."
    else
      "No remuneration is foreseen for the assigned activities, but the mere reimbursement of strictly necessary expenses " \
      "up to a maximum amount of #{euro(repayment.expected_refund)}, resulting from the original supporting documents to be delivered to the Department " \
      "Administrative Offices by Prof. #{repayment.seminar.speaker}. " \
      "The supporting documents proving that the expenses have been incurred can be reimbursed within the limits and in compliance " \
      "with the University Regulations on Travels and Reimbursements. The reimbursement of expenses is not subject to any withholding  "\
      "tax, it will be paid upon submission of an expense report (Bill of Costs) at the end of the activity."
    end
  end

  # compenso + rimborso spese
  def _payment_and_refound_string(repayment, lang)
    if lang == "it"
      "Per il presente incarico è previsto un compenso lordo percipiente pari a #{euro(repayment.lordo_percipiente)} " \
      "e il rimborso delle spese strettamente necessarie risultanti dai documenti giustificativi visionati e trattenuti " \
      "in originale dall’Ufficio Amministrazione. Il compenso e il rimborso spese sono assoggettati alle ritenute previste " \
      "a termini di legge, verranno corrisposti previa presentazione di nota spese al termine dell’incontro, e sono subordinati " \
      "alla regolare esecuzione di quest’ultimo. I documenti giustificativi comprovanti il sostenimento delle spese possono essere " \
      "rimborsati entro i massimali ed in conformità alla disciplina di cui al Regolamento Missioni dell’Università."
    else
      ""
    end
  end

  def payment_and_refound_string(repayment, lang)
    if repayment.payment.to_f > 0
      if repayment.refund
        _payment_and_refound_string(repayment, lang)
      else
        _payment_string(repayment, lang)
      end
    else
      _refund_string(repayment, lang)
    end
  end

  def repayment_header(docx)
    logopath = "#{Rails.root}/app/assets/images/sigillo1.png"
    docx.img logopath do
      width 50
      height 50
      align :center
    end

    docx.p "ALMA MATER STUDIORUM - UNIVERSITÀ DI BOLOGNA", align: :center, bold: true
    docx.p "Dipartimento di Matematica", align: :center, bold: true
  end

  def corresponsione(repayment)
    if repayment.payment
      "di un compenso per prestazione occasionale pari a € #{repayment.lordo_percipiente} lordo percipiente"
    else
      "del mero rimborso spese"
    end
  end

  def decree_spending(repayment)
    if repayment.refund
      "a titolo gratuito con corresponsione del mero rimborso spese"
    elsif repayment.payment
      "con corresponsione di un compenso per un importo pari a € #{repayment.lordo_percipiente} lordo percipiente"
    end
  end

  def decree_spending_upper_limit(repayment)
    if repayment.refund
      "fino ad un importo di €" + repayment.expected_refund.to_s
    elsif repayment.payment
      "fino ad un importo di €" + repayment.lordo_ente.to_s
    end
  end

  def proponent_and_holder(seminar)
    u = seminar.user
    h = seminar.repayment.fund.holder
    if u == h
      u.to_s
    else
      "#{u} e #{h}"
    end
  end

  # FIXME
  def considerations(repayment)
    if repayment.position&.phd?
      "che le attività di partecipazione a seminari in qualità di conferenzieri svolta dai dottorandi sono da considerare " \
      "attività di divulgazione scientifica ricomprese nello status degli stessi, pertanto  esulano dal " \
      "campo di applicazione dell'art. 7, comma 6, del D.Lgs. 165/2001"
    else
      "l’art. 7 del D.Lgs. 165 del 2001, in particolare sul conferimento di incarichi di collaborazione"
    end
  end

  def he_she_proposes(repayment)
    if repayment.payment
      "compenso lordo di euro #{repayment.lordo_ente}"
    else
      "rimborso spese di viaggio e/o vitto e/o alloggio, in conformità ai massimali di spesa e alla disciplina di cui al Regolamento Missioni"
      # :   □ Gruppo A  □ Gruppo B (1) (2)"
    end
  end

  def letter_defaults(docx)
    full_size = 18

    docx.style do
      id "Normal"
      name "Normal"
      font "Serif"
      size full_size
      line 300
    end

    docx.page_margins do
      left 800   # sets the left margin. units in twips.
      right 800  # sets the right margin. units in twips.
      top 600    # sets the top margin. units in twips.
      bottom 600 # sets the bottom margin. units in twips.
    end
  end

  def field_or_underscores(s, size: 20)
    s.blank? ? ("_" * size) : s
  end

  def status_class(repayment)
    c = "list-group-item list-group-item-action"
    if repayment.complete?
      c + " list-group-item-success"
    elsif repayment.notified
      c + " list-group-item-primary"
    else
      c + " list-group-item-light"
    end
  end
end
