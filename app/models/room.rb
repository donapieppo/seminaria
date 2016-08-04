class Room < ApplicationRecord 
  has_many   :seminars
  belongs_to :place 

  default_scope -> { order("name ASC") }

  validates_presence_of :name

  def to_s
    self.name
  end
end


