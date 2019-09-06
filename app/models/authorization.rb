class Authorization
  # authlevels: hash with organization_id as key e authlevel as value.
  # @authlevel[46] = Authorization::TO_ADMIN 
  # means that seld.user can admin organization with id=46
  attr_reader :authlevels

  TO_READ   = 1
  TO_MANAGE = 2
  TO_CESIA  = 3

  # Authorization depends on client ip and user
  def initialize(client_ip, user)
    @user      = user
    @client_ip = client_ip
    @is_cesia  = CESIA_UPN.include?(@user.upn) 

    @authlevels = Hash.new

    update_authlevels_by_user(@user)

    if @is_cesia and o = Organization.first
      @authlevels[o.id] = TO_CESIA
    end
  end

  def organizations
    Organization.order(:name).find(@authlevels.keys)
  end

  # multi_organizations e' false/true se l'utente
  # ha accesso ad una sola struttura o a piu' 
  def multi_organizations?
    @authlevels and @authlevels.size > 1 
  end

  def get_authlevel_for_organization(organization)
    @authlevels[organization.id]
  end

  def first_organization_id
    @authlevels.keys.first
  end

  # per visualizzazione livelli di autorizzazione
  def self.level_description(level, html=1)
    case level
      when TO_READ
        I18n.t(:can_read)
      when TO_MANAGE
        I18n.t(:can_manage)
      when TO_CESIA
        I18n.t(:is_cesia)
    end
  end

  def self.all_level_list
    [TO_READ, TO_MANAGE]
  end

  def can_read?(oid)
    return true
    oid = oid.id if oid.is_a?(Organization)
    @authlevels[oid] && @authlevels[oid] >= TO_READ
  end

  def can_manage?(oid)
    oid = oid.id if oid.is_a?(Organization)
    @authlevels[oid] && @authlevels[oid] >= TO_MANAGE
  end

  def is_cesia?
    @is_cesia
  end

  private 

  # vince sempre il net piu' specifico (tra 137.204.134.0 e 137.204.0.0 vince il primo)
  # per quanto riguarda la stessa struttura
  #
  # aggiorna @authlevels in base all'ip
  def update_authlevels_by_ip(client_ip)
  end

  # se c'e' la rete nel database allora aggiorno con quello che trovo
  def update_authlevels_by_network(net)
  end

  # un user puo' essere in diverse organizations con diversi authlevels
  # se si trova nel database admin sovrascrivo authlevel di update_authlevels_by_network
  def update_authlevels_by_user(user)
    user.permissions.each do |permission|
      if @is_cesia
        @authlevels[permission.organization_id] = TO_CESIA
      else
        @authlevels[permission.organization_id] = permission.authlevel.to_i
      end
    end
  end
end

