class Cycle < ApplicationRecord
  belongs_to :organization
  belongs_to :user
  has_many :seminars

  validates :title, :committee, presence: true

  def to_s
    self.title
  end
end
