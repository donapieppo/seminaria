class Position < ApplicationRecord
  has_many :repayments

  def to_s
    self.name
  end

  def phd?
    self.code == 'phdstudent'
  end
end
