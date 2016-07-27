class User < ActiveRecord::Base
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

end

