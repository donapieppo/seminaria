class Repayment < ApplicationRecord
  belongs_to :seminar
  belongs_to :holder, class_name: 'User', foreign_key: :holder_id, optional: true
  belongs_to :fund, optional: true
  belongs_to :position, optional: true
  has_many   :documents, dependent: :destroy
  has_many   :curricula_vitae, dependent: :destroy
  has_many   :id_cards, dependent: :destroy

  # validates :taxid, format: { with: /\A[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]\z/i, message: 'Controllare il formato del codice fiscale' }, allow_nil: true, allow_blank: true

  validate :payment_limits
  validate :speaker_arrival_departure_validation
  validate :validate_fund_and_holder

  after_create :create_spkr_token

  ADAPT_GROSS_VALUE       = 0.92165898
  IRAP                    = 0.085 # 8,5%
  IRPEF_ITALIAN           = 0.2   # 20%
  IRPEF_FOREIGN           = 0.3   # 30%
  ADAPT_NET_ITALIAN_VALUE = 1.25 
  ADAPT_NET_FOREIGN_VALUE = 1.42858142

  def payment_limits
    if self.seminar.on_line && self.lordo_percipiente && self.lordo_percipiente > 200
      self.errors.add(:payment, 'il compenso massimo erogabile a conferenzieri per seminari on line è pari a 200 Euro lordo ente, corrispondenti a 184,33 Euro lordo percipiente (147,47 Euro netti per conferenzieri con residenza fiscale in Italia; 129,03 euro netti per conferenzieri con residenza fiscale estera)')
    elsif self.italy && self.lordo_percipiente && self.lordo_percipiente > 500
      self.errors.add(:payment, 'il compenso massimo erogabile a conferenzieri con residenza fiscale in Italia è pari a Euro 500 lordo percipiente (400 euro nette; 542,50 euro lordo ente)')
    end
  end

  def speaker_arrival_departure_validation
    return true if self.seminar.on_line

    return true unless (self.refund || self.payment)

    if self.speaker_departure.blank?
      self.errors.add(:speaker_departure, 'È necessario inserire la data di partenza da Bologna del relatore')
    end
    if self.speaker_arrival.blank?
      self.errors.add(:speaker_arrival, 'È necessario inserire la data di arrivo a Bologna del relatore')
    end
    if self.speaker_arrival.present? && self.speaker_departure.present?
      if self.speaker_departure < self.speaker_arrival
        self.errors.add(:speaker_departure, "La partenza non può essere precedente all'arrivo.")
      end
      if self.speaker_arrival > self.seminar.date
        self.errors.add(:speaker_arrival, 'Il relatore non può arrivare a Bologna dopo la data prevista per il seminario.')
      end
    end
  end

  def validate_fund_and_holder
    if self.fund
      (self.fund.holder_id == self.holder_id) or self.errors.add(:fund, 'ERRORE')
    end
  end

  # Caso 1: Il richiedente inserisce il compenso netto che viene liquidato allo speaker (compenso netto = CN). 
  #         Nella lettera dobbiamo inserire il valore del lordo percipiente (LP).
  #         X STRANIERI: CN x 1,42858142. Esempio: CN = 100,00 LP = 100 x 1,42858142 = 142,86
  #         X ITALIANI:  CN x 1,25.       Esempio: CN = 100,00 LP = 100 x 1,25 = 125,00
  #
  # Caso 2: Il richiedente inserisce il compenso Lordo Ente che esce dal fondo (LE). 
  #         Nella lettera dobbiamo sempre inserire il valore del lordo percipiente (LP). La formula è:
  #         LE x 0,92165898. Esempio: LE = 155,00 LP = 100 x 0,92165898 = 142,86
  def lordo_percipiente
    return unless (self.payment && self.payment > 0)
    res = if self.gross
            self.payment * ADAPT_GROSS_VALUE
          else
            self.italy ? self.payment * ADAPT_NET_ITALIAN_VALUE : self.payment * ADAPT_NET_FOREIGN_VALUE
          end
    res.round(2)
  end

  # Nel primo caso per calcolare da lordo ente a netto la formula è il lordo percipiente - la ritenuta irpef (20 o 30 percento a secondo che siano rispettivamente italiani o stranieri), ossia, 
  # per italiani: LORDO ENTE * 0,92165898 = LORDO SOGGETTO --> NETTO = LORDO SOGGETTO - LORDO SOGGETTO * 20%. 
  # Per stranieri: LORDO ENTE * 0,92165898 = LORDO SOGGETTO --> LORDO SOGGETTO - LORDO SOGGETTO * 30%.
  # Nel secondo caso per passare da netto a Lordo Ente si aggiunge la variabile IRAP (8,5 percento del Lordo Soggetto), che è a nostro carico. Quindi
  # Per italiani: NETTO * 1,25 = LORDO SOGGETTO. LORDO ENTE = LORDO SOGGETTO*8,5% + LORDO SOGGETTO
  # Per stranieri: NETTO * 1,42858142 = LORDO SOGGETTO. LORDO ENTE = LORDO SOGGETTO*8,5% + LORDO SOGGETTO
  #
  # netto che prende lo speaker (in tasca)
  def netto_percipiente
    return unless (self.payment && self.payment > 0)
    self.gross or return self.payment.round(2)
    lordo_percipiente = self.payment * 0.92165898
    if self.italy
      (lordo_percipiente - lordo_percipiente * IRPEF_ITALIAN).round(2)
    else
      (lordo_percipiente - lordo_percipiente * IRPEF_FOREIGN).round(2)
    end
  end

  # lordo_ente 
  def lordo_ente
    return unless (self.payment && self.payment > 0)
    self.gross and return self.payment.round(2)
    lordo_percipiente = self.payment * (self.italy ? 1.25 : 1.42858142)
    (lordo_percipiente + lordo_percipiente * 0.085).round(2)
  end

  def letter_filename
    clean_speaker_name = self.seminar.speaker.downcase.gsub(' ', '_')
   "richiesta_compenso_#{clean_speaker_name}.pdf"
  end

  def letter_filename_docx(what)
    clean_speaker_name = self.seminar.speaker.downcase.gsub(' ', '_')
   "#{what}_per_seminario_di_#{clean_speaker_name}.docx"
  end

  def speaker_with_title
    if self.name.blank? || self.surname.blank?
      self.seminar.speaker_with_title
    else
      self.seminar.speaker_title + ' ' + self.name + ' ' + self.surname
    end
  end

  def position_to_s
    return ' - ' unless self.position_id
    self.position.code == 'other' ? self.role : self.position.name
  end

  def create_spkr_token
    unless self.spkr_token
      self.update_attribute(:spkr_token, SecureRandom.urlsafe_base64(50))
    end
  end
  
  # def missing_payment_and_refund?
  #   ! ((self.payment.to_i > 0) || (self.expected_refund.to_i > 0))
  # end

  # def holder_ok?
  #   self.holder_id
  # end

  # def speaker_reason_ok?
  #   ! ((self.documents.empty?) || (self.reason.blank?))
  # end

  # def speaker_anagrafica_ok?
  #   ! ((self.name.blank?) || (self.surname.blank?) || (self.birth_place.blank?) || (self.birth_date.blank?))
  # end

  # def speaker_role_ok?
  #   ! ((self.affiliation.blank?) || (self.position_id.nil?) || (self.email.blank?))
  # end

  # def speaker_address_ok?
  #   ! ((self.address.blank?) || (self.postalcode.blank?) || (self.city.blank?))
  # end

  # def all_ok_to_send?
  #   holder_ok? && speaker_reason_ok? &&  speaker_anagrafica_ok? && speaker_role_ok? && speaker_address_ok? 
  # end

  # def correct_data_group?(what)
  #   case what
  #   when :reason
  #     speaker_reason_ok?
  #   when :fund
  #     if self.holder_id == self.seminar.user_id
  #       (self.holder_id and self.fund_id)
  #     else
  #       self.holder_id
  #     end
  #   when :compensation
  #     ! missing_payment_and_refund?
  #   when :speaker_details
  #     speaker_anagrafica_ok? and speaker_address_ok? and speaker_role_ok?
  #   else
  #     false
  #   end
  # end
end
