# speaker_on_line e' in database
class Seminar < ApplicationRecord
  include Calendar

  belongs_to :user
  belongs_to :organization
  belongs_to :place, optional: true
  belongs_to :cycle, optional: true
  belongs_to :serial, optional: true
  belongs_to :conference, optional: true
  has_many   :documents, dependent: :destroy
  has_one    :repayment, dependent: :destroy
  has_and_belongs_to_many :arguments
  has_one    :zoom_meeting
  # has_many   :registrations

  scope :future, -> { where('seminars.date > DATE_ADD(UTC_TIMESTAMP(), INTERVAL -2 hour)') }
  scope :past, -> { where('seminars.date <= DATE_ADD(UTC_TIMESTAMP(), INTERVAL -2 hour)') }
  scope :this_year, -> { where('YEAR(seminars.date) = YEAR(NOW())') }
  scope :date_today, -> { where('DATE(seminars.date)=CURDATE()') }

  before_save :manage_place_choice, :date_in_future

  validates :title, :speaker_title, :speaker, :date, presence: true
  validates :meeting_url, :link, format: { with: URI.regexp(['http', 'https']), allow_blank: true }

  # place_id == 1 -> 'non definita'
  # place_id == 2 -> 'esterna' -> si puo' mettere descrizione
  def manage_place_choice
    self.place_description = nil unless (self.place_id == 2)
  end

  # convenzione che fino ad due ore fa non e' passato
  def past?
    self.date < Time.now - 2.hour
  end

  # non so se sono amministratore
  # FIXME TODO
  def date_in_future
  end

  def where_to_s(visible: false)
    res = ""
    res += self.place_to_s 
    res += " e " if self.in_presence && self.on_line
    res += self.on_line_to_s(visible: visible)
    res
  end

  def place_to_s
    if self.in_presence
      case self.place_id
      when 2
        "#{I18n.t :place} #{self.place_description}"
      when nil
        'Aula non definita'
      else
        "#{I18n.t :place} #{self.place.to_s}"
      end
    else
      ''
    end
  end

  def on_line_to_s(visible: false)
    if self.on_line
      # if visible || (self.meeting_visible && ! self.meeting_url.blank?)
      if self.meeting_url.blank?
        'on-line'
      else
        "on-line all'indirizzo: #{self.meeting_url}"
      end
    else
      ''
    end
  end

  def to_s
    self.title
  end

  def to_long_s
    "#{self.date.strftime('%d/%m/%Y')}: #{self.speaker} (#{self.title})"
  end

  def zoom_topic
    "#{self.speaker_title} #{self.speaker}: #{self.title}"
  end

  def female_speaker?
    self.speaker_title =~ /\.ssa|\.ra/
  end

  def speaker_with_date
    "#{self.date.strftime('%d/%m/%Y')}: #{self.speaker}"
  end

  def speaker_with_title
    self.speaker_title + ' ' + self.speaker
  end

  def project
    # caso particolare seminari ciclo MANET
    if self.serial_id == 9 || self.cycle_id == 12 || self.id == 1361
      "nell'ambito del Progetto Fondi U.E. MANET del prof. Giovanna Citti."
    elsif self.repayment&.fund_id && self.repayment&.holder_id
      "nell'ambito del Progetto #{self.repayment.fund} del prof. #{self.repayment.holder}"
    else
      ''
    end
  end

  # too late if:
  # - seminar start in less than repayment_deadline days (see configuration)
  # - the repayment has a speaker_arrival and the arrival is before repayment_deadline days
  def too_late_for_repayment?
    start_date_possible_repayment = Date.today + Rails.configuration.repayment_deadline.days

    return true if (self.date < start_date_possible_repayment)

    return true if (self.repayment&.speaker_arrival && self.repayment.speaker_arrival < start_date_possible_repayment)

    false
  end

  def day
    self.date
  end

  def hour
    self.date.hour
  end

  def minute
    self.date.min
  end

  def start_time
    self.date
  end

  # to use in simple form
  def zoom_meeting_create
    ! self.zoom_meeting.blank?
  end

  def in_conference?
    self.conference_id
  end
end
