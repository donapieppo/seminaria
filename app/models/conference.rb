class Conference < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  has_many :seminars

  validates :title, uniqueness: true
  validates :committee, presence: true

  def to_s
    self.title
  end
  
  # convenzione che fino ad due ore fa non e' passato
  def past?
    self.start_date < Time.now - 2.hour
  end
end

