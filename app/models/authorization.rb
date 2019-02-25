class Authorization < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  after_save    :clear_cache
  after_destroy :clear_cache

  def to_s
    "#{self.authlevel} #{self.user} on #{self.organization}"
  end

  def clear_cache
    Rails.logger.info("Cleared Authorization cache")
    @@_auths = nil
  end

  def self.can_manage?(_user_id, _organization_id)
    _user_id = _user_id.id if _user_id.is_a?(User)
    _organization_id = _organization_id.id if _organization_id.is_a?(Organization)

    auths = user_auths_cache(_user_id)
    auths[_organization_id] and auths[_organization_id] > 0
  end

  def self.can_admin?(_user_id, _organization_id)
    _user_id = _user_id.id if _user_id.is_a?(User)
    _organization_id = _organization_id.id if _organization_id.is_a?(Organization)

    auths = user_auths_cache(_user_id)
    auths[_organization_id] and auths[_organization_id] > 1
  end

  private 

  # get all the authorizations for the user
  # @@_auth[user_id][organization_id] = 2 
  def Authorization.user_auths_cache(user_id)
    @@_auths ||= Hash.new
    if ! @@_auths[user_id]
      @@_auths[user_id] = Hash.new
      Authorization.order('authlevel asc').where(user_id: user_id).each do |auth| # order to get the higher
        @@_auths[user_id][auth.organization_id] = auth.authlevel
      end
    end
    @@_auths[user_id]
  end

  # version without cache
  # def self.can_manage?(_user_id, _organization_id)
  #   _user_id = _user_id.id if _user_id.is_a?(User)
  #   _organization_id = _organization_id.id if _organization_id.is_a?(Organization)

  #   @@_auths[_user_id] ||= Hash.new
  #   @@_auths[_user_id] 
  #   Authorization.where(user_id: _user_id).where(organization_id: _organization_id).where('authlevel > 0').any?
  # end

  # def self.can_admin?(_user_id, _organization_id)
  #   _user_id = _user_id.id if _user_id.is_a?(User)
  #   _organization_id = _organization_id.id if _organization_id.is_a?(Organization)

  #   Authorization.where(user_id: _user_id).where(organization_id: _organization_id).where('authlevel > 1').any?
  # end

end

