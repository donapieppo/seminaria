class User < ActiveRecord::Base
  include DmUniboCommon::User

  has_many :authorizations

  has_many :seminars
  has_many :cycles
  has_many :repayments, foreign_key: :holder_id
  has_many :funds, foreign_key: "holder_id"

  def has_active_funds?
    self.funds.active.any?
  end

  def self.abbr_titles
    ['Prof.', 'Prof.ssa', 'Dott.', 'Dott.ssa']
  end
   
  # DSA 
  
  def self.update_from_anagrafica_unica(id_anagrafica_unica)
    user = User.where(id: id_anagrafica_unica.to_i).first
    if ! user
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

  def get_authlevel(organization)
    organization_id = organization.is_a?(Integer) ? organization : organization.id
    @auth ||= Hash.new
    if ! @auth[organization_id]
      _authorization = self.authorizations.where(organization_id: organization_id).order('authlevel desc').first
      if _authorization
        @auth[organization_id] = _authorization.authlevel
      else
        @auth[organization_id] = 0
      end
    end
    @auth[organization_id]
  end

  def can_manage?(organization)
    get_authlevel(organization) > 0
  end

  def can_admin?(organization)
    get_authlevel(organization) > 1
  end
end

