class Authorization < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  def to_s
    "#{self.authlevel} #{self.user} on #{self.organization}"
  end

  # get all the authorizations
  # @auth[user_id][organization_id] = 2 
  def self.user_auths(user_id)
    @auth ||= Hash.new
    if ! @auth[user_id]
      @auth[user_id] = Hash.new
      Authorization.order('authlevel asc').each do |auth| # order to get the higher
        @auth[user_id][auth.organization_id] = auth.authlevel
      end
    end
    @auth[user_id]
  end

  def self.can_manage?(_user_id, _organization_id)
    _user_id = _user_id.id if _user_id.is_a?(User)
    _organization_id = _organization_id.id if _organization_id.is_a?(Organization)

    auths = Authorization.user_auths(_user_id)
    auths[_organization_id] and auths[_organization_id] > 0
  end

  def self.can_admin?(_user_id, _organization_id)
    _user_id = _user_id.id if _user_id.is_a?(User)
    _organization_id = _organization_id.id if _organization_id.is_a?(Organization)

    auths = Authorization.user_auths(_user_id)[_organization_id] 
    auths[_organization_id] and auths[_organization_id] > 1
  end

end

