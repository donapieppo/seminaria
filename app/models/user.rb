class User < ApplicationRecord
  include DmUniboCommon::User

  has_many :seminars
  has_many :cycles
  has_many :highlights
  has_many :approvals
  has_many :funds, foreign_key: "holder_id"

  def is_commissioner?
    COMMISSIONERS.include?(self.upn) or self.is_admin?
  end

  def is_publisher?
    PUBLISHERS.include?(self.upn) or self.is_admin?
  end

  # amministrazione
  def is_manager?
    MANAGERS.include?(self.upn) or self.is_admin?
  end

  def is_holder?
    self.funds.active.any?
  end

  def self.commissioners_mails
    COMMISSIONERS
  end
   
  def self.publishers_mails
    PUBLISHERS
  end
   
  def self.manager_mails
    MANAGERS_MAILS
  end

  def self.abbr_titles
    ['Prof.', 'Prof.ssa', 'Dott.', 'Dott.ssa']
  end
   
end

