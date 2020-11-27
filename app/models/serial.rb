class Serial < ApplicationRecord
  belongs_to :organization
  has_many :seminars

  scope :active, -> { where(active: 1) }

  validates_presence_of :title, :committee

  def to_s
    self.title
  end
end
