class Organization < ApplicationRecord
  has_many :permissions

  has_many :seminars
  has_many :funds
  has_many :serials
  has_many :cycles
  has_many :places
  has_many :arguments

  def to_s
    self.name
  end

  def manager_mails
    self.permissions.includes(:user).map{|a| a.user.upn}.to_a
  end
end

