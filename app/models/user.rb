class User < ApplicationRecord
  include DmUniboCommon::User

  has_many :seminars
  has_many :cycles
  has_many :conferences
  has_many :repayments, foreign_key: :holder_id
  has_many :funds, foreign_key: "holder_id"
  # has_many :registrations

  def has_active_funds?
    self.funds.active.any?
  end

  def self.abbr_titles
    ["Prof.", "Prof.ssa", "Dott.", "Dott.ssa"]
  end

  # DSA
  def self.update_from_anagrafica_unica(id_anagrafica_unica)
    user = User.where(id: id_anagrafica_unica.to_i).first
    unless user
      result = dsaSearchClient.find_user(id_anagrafica_unica)
      if result.count == 0
        raise NoUser
      else
        dsa_user = result.users.inject(nil) do |res, u|
          res = u if u.id_anagrafica_unica.to_i == id_anagrafica_unica.to_i
        end or return NoUser
        user = User.new({id:      dsa_user.id_anagrafica_unica.to_i,
                         upn:     dsa_user.upn,
                         name:    dsa_user.name,
                         surname: dsa_user.sn})
        user.save!
        Rails.logger.info("Created user #{user.inspect}")
      end
    end
    user
  end

  def seminars_on_my_funds_last_year
    seminar_ids = self.repayments.map(&:seminar_id)
    Seminar.where(id: seminar_ids)
  end

  def registration(seminar)
    self.registrations.where(seminar_id: seminar.id).first
  end
end
