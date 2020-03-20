class Organization < ApplicationRecord
  include DmUniboCommon::Organization

  has_many :permissions, class_name: "DmUniboCommon::Permission"

  has_many :seminars
  has_many :funds
  has_many :serials
  has_many :cycles
  has_many :places
  has_many :arguments

  def manager_mails
    self.permissions.includes(:user).map{|a| a.user.upn}.to_a
  end
end

