# user_id, organization_id, authlevel
class Admin < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :organization, presence: true
  validates :user, presence: true
  validates :authlevel, inclusion: { in: Authorization.all_level_list, message: "Errore interno al sistema su Admin.authlevel. Contattare Assistenza." }

  def to_s
    "#{self.authlevel} #{self.user} on #{self.organization}"
  end

  def self.can_see?(_user_id, _organization_id)
    false
  end

  def self.can_manage?(_user_id, _organization_id)
    false
  end

  def self.can_admin?(_user_id, _organization_id)
    false
  end

  def authlevel_string
    case self.authlevel
    when 1
      'lettore'
    when 2
      'amministratore'
    when 3
      'super'
    end
  end

end

