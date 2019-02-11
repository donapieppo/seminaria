class Organization < ApplicationRecord
  has_many :seminars

  def to_s
    self.name
  end
end

