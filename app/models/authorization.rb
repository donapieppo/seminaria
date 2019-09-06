class Authorization
  # authlevels: hash with organization_id as key e authlevel as value.
  # @authlevel[46] = Authorization::TO_ADMIN 
  # means that seld.user can admin organization with id=46
  attr_reader :authlevels

  TO_ADMIN  = 40
  TO_CESIA  = 100

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
  alias :multi_organizations :multi_organizations?

  # puo' accedere al programma?
  def has_authorization?
    @authlevels.size > 0
  end

  def get_authlevel_for_organization(organization)
    @authlevels[organization.id]
  end

  def first_organization_id
    @authlevels.keys.first
  end

  # non c'e' cesia che si mette a mano
  def self.admin_level_list
    [TO_READ,TO_ORDER,TO_BOOK,TO_UNLOAD,TO_GIVE,TO_ADMIN,TO_EDIT]
  end

  def self.all_level_list
    [TO_READ,TO_ORDER,TO_BOOK,TO_UNLOAD,TO_GIVE,TO_ADMIN,TO_EDIT,TO_CESIA]
  end

  def self.admin_form_level_list
    admin_level_list.map {|x| [Authorization.level_description(x), x] }
  end

  # per visualizzazione livelli di autorizzazione
  def self.level_description(level, html=1)
    case level
      when TO_READ
        I18n.t(:can_read)
      when TO_BOOK 
        I18n.t(:can_book)
      when TO_UNLOAD
        I18n.t(:can_unload)
      when TO_GIVE
        I18n.t(:can_give)
      when TO_ADMIN
        I18n.t(:can_admin)
      when TO_EDIT
        I18n.t(:can_edit)
      when TO_CESIA
        I18n.t(:is_cesia)
    end
  end

  # FIXME
  def can_see?(oid)
    return true
    oid = oid.id if oid.is_a?(Organization)
    @authlevels[oid] && @authlevels[oid] >= TO_ADMIN
  end

  def can_manage?(oid)
    oid = oid.id if oid.is_a?(Organization)
    @authlevels[oid] && @authlevels[oid] >= TO_ADMIN
  end

  def can_admin?(organization)
    oid = oid.id if oid.is_a?(Organization)
    @authlevels[oid] && @authlevels[oid] >= TO_CESIA
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
    user.admins.each do |admin|
      if @is_cesia
        @authlevels[admin.organization_id] = TO_CESIA
      else
        @authlevels[admin.organization_id] = admin.authlevel.to_i
      end
    end
  end

end

