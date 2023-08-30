class Conference < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  has_many :seminars

  validates :title, uniqueness: true
  validates :committee, presence: true

  after_update :set_date_in_seminars

  def to_s
    self.title
  end

  # convenzione che fino ad due ore fa non e' passato
  def past?
    self.start_date < Time.now - 2.hour
  end

  def set_date_in_seminars
    self.seminars.each do |s|
      s.update(date: self.start_date)
    end
  end
end
