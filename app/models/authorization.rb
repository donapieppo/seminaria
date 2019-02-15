class Authorization < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  def to_s
    "#{self.authlevel} #{self.user} on #{self.organization}"
  end
end

