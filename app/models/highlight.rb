class Highlight < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_many :approvals
  belongs_to :user

  validates_presence_of :proponent, :name, :description

  after_save :update_priority_order

  scope :approved,   -> { where('approved_at IS NOT NULL') }
  scope :unapproved, -> { where('approved_at IS NULL') }
  scope :refused,    -> { where('refused IS NOT NULL') }
  scope :unrefused,  -> { where('refused IS NULL') }
  scope :priorized,  -> { where('position IS NOT NULL').order('position asc') }

  Priorities = ['low', 'normal', 'high', 'always_top']
  Priorities_weigth = {'low' => 0.5, 'normal' => 1, 'high' => 2, 'always_top' => 100}

  def voted_by?(user)
    self.approvals.map(&:user_id).include?(user.id)
  end

  def update_priority_order
    # sempre, magari e' un disabborove
    # return if self.approved_at.nil?
    Highlight.set_priority_order
  end

  # UTILIZZARE IN CRON per ristabilire gli ordinamenti 
  #
  # algoritmo per stabilire ordinamento
  # distanza in giorni / peso
  # aggiungiamo un giorno altrimenti tutte quelle di oggi pesano zero
  # position e' un int e moltiplichiamo per 100 
  # FIXME NOW() mysql
  def self.set_priority_order
    today = Date.today
    # annulliamo quelli non approved
    Highlight.unapproved.where("position IS NOT NULL").each {|h| h.update_column(:position, nil)}
    # annulliamo quelli fuori dal periodo
    Highlight.approved.where("(visible_from > NOW()) OR (visible_to < NOW())").each {|h| h.update_column(:position, nil)}
    # abilitiamo e ordiniamo quelli giusti
    Highlight.approved.where("visible_from <= NOW()").where("visible_to >= NOW()").each do |h|
      # visible_from e to sono date
      days_diff = (today - h.visible_from) + 1
      weight = Priorities_weigth[h.priority]
      h.update_column(:position, days_diff/weight*100)
    end
  end

  def publish(priority)
    if ! Priorities.include?(priority) 
      self.errors.add(:priority, 'non corretta')
      return false
    end
    self.update_attributes(:priority => priority, :approved_at => Time.now)
  end

  def refuse
    self.update_attributes(:approved_at => nil, :refused => 1, :priority => nil)
  end

  def approved?
    self.approved_at
  end

  def refused?
    self.refused
  end

  def under_evaluation?
    ! (self.approved_at or self.refused)
  end
end
