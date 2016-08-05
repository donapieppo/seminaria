# committee = Organizzatore
class Seminar < ApplicationRecord
  include Calendar

  belongs_to :user
  belongs_to :organization, required: true
  belongs_to :room,         required: false
  belongs_to :cycle,        required: false
  belongs_to :serial,       required: false
  has_many   :documents, dependent: :destroy
  has_one    :repayment, dependent: :destroy
  has_and_belongs_to_many :topics

  scope :future, -> { where("date > DATE_ADD(NOW(), INTERVAL -2 hour)") }

  validates_presence_of :title, :date, :speaker_title, :speaker

  # place_id == 1 -> 'non definita'
  # place_id == 2 -> 'esterna' -> si puo' mettere descrizione
  # def manage_place_choice
  #   self.place_description = nil unless (self.place_id == 2)
  # end

  # convenzione che fino ad un'ora fa non e' passato
  def past?
    self.date < Time.now - 1.hour
  end

  def place_to_s
    if self.room_id
      self.room.to_s + " " + self.room.place.to_s
    else
      I18n.t(:undefined_room)
    end
  end

  def arguments_string
    a = self.topics
    a.empty? and return ""
    if a.first.name == 'interdisciplinare'
      "seminario interdisciplinare"
    else
      ("seminario di " + a.to_a.join(", ")).html_safe
    end
  end

  def to_s
    self.title
  end

  def to_long_s
    "#{self.date.strftime("%d/%m/%Y")}: #{self.speaker} (#{self.title})"
  end

  def female_speaker?
    self.speaker_title =~ /\.ssa|\.ra/
  end

  def speaker_with_title
    self.speaker_title + " " + self.speaker
  end

  def project
    # caso particolare seminari ciclo MANET
    if self.serial_id == 9 or self.cycle_id == 12 or self.id == 1361
      "nell'ambito del Progetto Fondi U.E. MANET del prof. Giovanna Citti."
    elsif self.repayment and self.repayment.fund_id and self.repayment.holder_id
      "nell'ambito del Progetto #{self.repayment.fund} del prof. #{self.repayment.holder}"
    else
      ""
    end
  end

  # Accrocchio :-) helps in _form.html.erb for seminar.input :place, collection: ...
  belongs_to :place
  def place_id=(id)
    @place_id = id
  end

  def place_id
    @place_id || (self.room_id ? self.room.place_id : 0)
  end
end

