# user_id, organization_id, authlevel
class Permission < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :organization, presence: true
  validates :user, presence: true
  validates :authlevel, inclusion: { in: Authorization.all_level_list, message: "Errore interno al sistema su Admin.authlevel. Contattare Assistenza." }

  def to_s
    "#{self.authlevel} #{self.user} on #{self.organization}"
  end

  def authlevel_string
    Authorization.level_description(self.authlevel)
  end
end

