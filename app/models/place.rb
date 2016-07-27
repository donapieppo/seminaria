class Place < ApplicationRecord 
  has_many :seminars

  default_scope -> { order("name ASC") }

  def to_s
    self.name
  end
end

