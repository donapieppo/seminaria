class Place < ApplicationRecord 
  has_many :seminars

  default_scope -> { order("name ASC") }

  def to_s
    self.name + " (" + self.address + " " + self.city + ")"
  end

  # other if a fake place in order to specify room by a free string in room_description
  def self.all_with_other
    self.all.to_a << self.new(id: 0, 
                              name: 'Altro', 
                              address: 'da inserire manualmente', 
                              city: '')
  end

end

