class Repayment < ApplicationRecord
  belongs_to :seminar
  belongs_to :holder, class_name: User, foreign_key: :holder_id
  belongs_to :fund
  # non ci basta che sia in seminario con type=cv. Ci piace di piu' cosi'. Anche solo perche' va visto da chi vede 
  # il seminario e questo va visto da chi vede il repayment
  has_many   :documents, dependent: :destroy

  validates :name, :surname, :email, :address, :postalcode, :city, :birth_date, :birth_place, :birth_country, :role, :affiliation, presence: true
  validates :speaker_arrival, :speaker_departure, :expected_refund, presence: true, if: :refund

  validate :payment_limit_for_italians

  ADAPT_GROSS_VALUE       = 0.92165898
  IRAP                    = 0.085 # 85%
  IRPEF_ITALAN            = 0.2   # 20%
  IRPEF_FOREIGN           = 0.3   # 30%
  ADAPT_NET_ITALIAN_VALUE = 1.25 
  ADAPT_NET_FOREIGN_VALUE = 1.42858142

  def payment_limit_for_italians
    return true unless self.italy
    if self.lordo_percipiente and self.lordo_percipiente > 500
      self.errors.add(:payment, "il compenso massimo erogabile a conferenzieri con residenza fiscale in Italia è pari a Euro 500 lordo percipiente (400 euro nette; 542,50 euro lordo ente)")
      return false
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
    (self.payment and self.payment > 0) or return
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
    (self.payment and self.payment > 0) or return
    self.gross or return self.payment.round(2)
    lordo_percipiente = self.payment * 0.92165898
    if self.italy
      (lordo_percipiente - lordo_percipiente * IRPEF_ITALAN).round(2)
    else
      (lordo_percipiente - lordo_percipiente * IRPEF_FOREIGN).round(2)
    end
  end

  # lordo_ente 
  def lordo_ente
    (self.payment and self.payment > 0) or return
    self.gross and return self.payment.round(2)
    lordo_percipiente = self.payment * (self.italy ? 1.25 : 1.42858142)
    (lordo_percipiente + lordo_percipiente * 0.085).round(2)
  end

  def letter_filename
    clean_speaker_name = self.seminar.speaker.downcase.gsub(' ','_')
   "richiesta_compenso_#{clean_speaker_name}.pdf"
  end

  def speaker_with_title
    if self.name.blank? or self.surname.blank?
      self.seminar.speaker_with_title
    else
      self.seminar.speaker_title + " " + self.name + " " + self.surname
    end
  end
end


