class Repayment < ApplicationRecord
  belongs_to :seminar
  belongs_to :holder, class_name: "User", foreign_key: :holder_id, optional: true
  belongs_to :fund, optional: true
  belongs_to :position, optional: true
  has_many :documents, dependent: :destroy
  has_many :curricula_vitae, dependent: :destroy
  has_many :id_cards, dependent: :destroy

  # validates :taxid, format: { with: /\A[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]\z/i, message: 'Controllare il formato del codice fiscale' }, allow_nil: true, allow_blank: true

  validate :payment_limits
  validate :speaker_arrival_departure_validation
  validate :validate_fund_and_holder

  after_create :create_spkr_token

  ADAPT_GROSS_VALUE = 0.92165898
  IRAP = 0.085 # 8,5%
  IRPEF_ITALIAN = 0.2 # 20%
  IRPEF_FOREIGN = 0.3 # 30%
  ADAPT_NET_ITALIAN_VALUE = 1.25
  ADAPT_NET_FOREIGN_VALUE = 1.42858142

  def complete?
    ugov.to_i > 0
  end

  def payment_limits
    lp = lordo_percipiente.to_i
    if seminar.speaker_on_line && lp > 200
      errors.add(:payment, "il compenso massimo erogabile a conferenzieri per seminari on line è pari a 200 Euro lordo ente, corrispondenti a 184,33 Euro lordo percipiente (147,47 Euro netti per conferenzieri con residenza fiscale in Italia; 129,03 euro netti per conferenzieri con residenza fiscale estera)")
    elsif italy && lp > 500
      errors.add(:payment, "il compenso massimo erogabile a conferenzieri con residenza fiscale in Italia è pari a Euro 500 lordo percipiente (400 euro nette; 542,50 euro lordo ente)")
    end
  end

  def speaker_arrival_departure_validation
    return true if seminar.speaker_on_line
    return true unless (refund || payment)

    if speaker_departure.blank?
      errors.add(:speaker_departure, "È necessario inserire la data di partenza da Bologna del relatore.")
    end
    if speaker_arrival.blank?
      errors.add(:speaker_arrival, "È necessario inserire la data di arrivo a Bologna del relatore.")
    end
    if speaker_arrival.present? && speaker_departure.present?
      if speaker_departure < speaker_arrival
        errors.add(:speaker_departure, "La partenza non può essere precedente all'arrivo.")
      end
      if speaker_arrival > (seminar.in_conference? ? seminar.conference.end_date : seminar.date.to_date)
        errors.add(:speaker_arrival, "Il relatore non può arrivare a Bologna dopo la data prevista per il seminario.")
      end
    end
  end

  def validate_fund_and_holder
    if self.fund
      (self.fund.holder_id == self.holder_id) or self.errors.add(:fund, "ERRORE")
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
    return unless with_payment?
    res = if self.gross
      self.payment * ADAPT_GROSS_VALUE
    else
      self.italy ? self.payment * ADAPT_NET_ITALIAN_VALUE : self.payment * ADAPT_NET_FOREIGN_VALUE
    end
    res.round(2)
  end

  # Nel primo caso per calcolare da lordo ente a netto la formula è il lordo percipiente - la ritenuta irpef
  #   (20 o 30 percento a secondo che siano rispettivamente italiani o stranieri), ossia,
  # per italiani: LORDO ENTE * 0,92165898 = LORDO SOGGETTO --> NETTO = LORDO SOGGETTO - LORDO SOGGETTO * 20%
  # Per stranieri: LORDO ENTE * 0,92165898 = LORDO SOGGETTO --> LORDO SOGGETTO - LORDO SOGGETTO * 30%.
  # Nel secondo caso per passare da netto a Lordo Ente si aggiunge la variabile IRAP (8,5 percento del Lordo Soggetto), che è a nostro carico. Quindi
  # Per italiani: NETTO * 1,25 = LORDO SOGGETTO. LORDO ENTE = LORDO SOGGETTO*8,5% + LORDO SOGGETTO
  # Per stranieri: NETTO * 1,42858142 = LORDO SOGGETTO. LORDO ENTE = LORDO SOGGETTO*8,5% + LORDO SOGGETTO
  #
  # netto che prende lo speaker (in tasca)
  def netto_percipiente
    return unless with_payment?
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
    return unless with_payment?
    self.gross and return self.payment.round(2)
    lordo_percipiente = self.payment * (self.italy ? 1.25 : 1.42858142)
    (lordo_percipiente + lordo_percipiente * 0.085).round(2)
  end

  def letter_filename
    clean_speaker_name = self.seminar.speaker.downcase.tr(" ", "_")
    "richiesta_compenso_#{clean_speaker_name}.pdf"
  end

  def speaker_with_title
    if self.name.blank? || self.surname.blank?
      self.seminar.speaker_with_title
    else
      self.seminar.speaker_title + " " + self.name + " " + self.surname
    end
  end

  def position_to_s
    return " - " unless self.position_id
    self.position.code == "other" ? self.role : self.position.name
  end

  def create_spkr_token
    unless self.spkr_token
      self.update_attribute(:spkr_token, SecureRandom.urlsafe_base64(50))
    end
  end

  def with_payment?
    payment.to_i > 0
  end

  def with_refund?
    !!refund
  end

  def clear_privacy!
    [:taxid, :address, :postalcode, :birth_date, :birth_place, :iban, :bank_name, :bank_address, :spkr_token, :swift, :aba].each do |x|
      p self.send("#{x}=".to_sym, "_")
    end
    self.spkr_token = nil
    self.save
  end

  def self.validate_spkr_token(x)
    x&.size == 67
  end

  def self.get_form_token(x)
    if validate_spkr_token(x)
      Repayment.where(spkr_token: x).first
    end
  end
end
