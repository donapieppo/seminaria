class Argument < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :seminars

  def to_s
    self.name
  end
end
