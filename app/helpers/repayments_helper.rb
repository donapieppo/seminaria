module RepaymentsHelper
  def payment_and_refound_string(repayment)
    if repayment.payment.blank? 
      "Per il presente incarico non è previsto alcun compenso ma il mero rimborso delle spese strettamente necessarie risultanti dai documenti giustificativi visionati e trattenuti in originale dall’Ufficio Amministrazione. I documenti giustificativi comprovanti il sostenimento delle spese possono essere rimborsati entro i massimali ed in conformità alla disciplina di cui al Regolamento Missioni dell’Università. Il rimborso spese non è assoggettato ad alcuna ritenuta, verrà corrisposto previa presentazione di nota spese al termine dell’incontro ed è subordinato alla regolare esecuzione di quest’ultimo."
    else
      if repayment.refund
        # compenso + rimborso spese
        "Per il presente incarico è previsto un compenso lordo percipiente pari a #{euro(repayment.lordo_percipiente)} e il rimborso delle spese strettamente necessarie risultanti dai documenti giustificativi visionati e trattenuti in originale dall’Ufficio Amministrazione. Il compenso e il rimborso spese sono assoggettati alle ritenute previste a termini di legge, verranno corrisposti previa presentazione di nota spese al termine dell’incontro, e sono subordinati alla regolare esecuzione di quest’ultimo. I documenti giustificativi comprovanti il sostenimento delle spese possono essere rimborsati entro i massimali ed in conformità alla disciplina di cui al Regolamento Missioni dell’Università."
      else 
        # compenso senza rimborso spese
        "Per il presente incarico è previsto un compenso lordo percipiente pari a #{euro(repayment.lordo_percipiente)}, assoggettato alle ritenute previste a termini di legge, corrisposto al termine dell’incontro e subordinato alla regolare esecuzione di quest’ultimo."
      end
    end
  end

  def repayment_header(docx)
    logopath = "#{Rails.root}/app/assets/images/sigillo1.png"
    docx.img logopath do
      width  50
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

  def proponent_and_holder(seminar)
    u = seminar.user
    h = seminar.repayment.fund.holder
    "#{u}" + ((u == h) ? "" : " e #{h}")
  end

  # FIXME 
  def considerations(repayment)
    if repayment.position and repayment.position.phd?
      "che le attività di partecipazione a seminari in qualità di conferenzieri svolta dai dottorandi sono da considerare attività di divulgazione scientifica ricomprese nello status degli stessi, pertanto  esulano dal campo di applicazione dell'art. 7, comma 6, del D.Lgs. 165/2001"
    else
      "l’art. 7 del D.Lgs. 165 del 2001, in particolare sul conferimento di incarichi di collaborazione"
    end
  end

  def he_she_proposes(repayment)
    if repayment.payment
      "compenso lordo di euro #{repayment.lordo_ente}"
    else
      "rimborso spese di viaggio e/o vitto e/o alloggio, in conformità ai massimali di spesa e alla disciplina di cui al Regolamento Missioni" # :   □ Gruppo A  □ Gruppo B (1) (2)"
    end
  end

  def letter_defaults(docx)
    full_size  = 20
    small_size = 12

    docx.style do
      id   'Normal'
      name 'Normal'
      font 'Serif'
      size full_size
      line 300 
    end

    docx.page_margins do
      left    800     # sets the left margin. units in twips.
      right   800     # sets the right margin. units in twips.
      top     600    # sets the top margin. units in twips.
      bottom  600    # sets the bottom margin. units in twips.
    end
  end

  def field_or_underscores(s, size: 20)
    s.blank? ? ('_' * size) : s
  end

  def status_class(repayment)
    c = 'list-group-item list-group-item-action'
    if repayment.complete?
      c + ' list-group-item-success'
    elsif repayment.notified
      c + ' list-group-item-primary'
    else
      c + ' list-group-item-light'
    end
  end
end
