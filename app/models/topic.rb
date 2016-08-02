class Topic < ApplicationRecord
  has_and_belongs_to_many :seminars

  def to_s
    self.name
  end
end
