class Organization < ActiveRecord::Base
  has_many :admins
  has_many :seminars

  validates :name, uniqueness: {}

  def to_s
    self.name + " (" + self.description + ")"
  end

  def short_description
    "#{self.name} - #{self.description[0..70]}"
  end

  def admins_string
    self.admins.map {|admin| admin.to_s}.join(', ')
  end

end
