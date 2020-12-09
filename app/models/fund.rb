class Fund < ApplicationRecord
  belongs_to :organization
  belongs_to :category
  belongs_to :holder, class_name: 'User', foreign_key: 'holder_id'
  has_many   :repayments

  validates :name, uniqueness: { scope: [:holder_id, :category_id], message: 'Il nome del fondo è stato già utilizzato.' }

  scope :active, -> { where('funds.available = 1') }

  def self.holders
    user_ids = Fund.active.select(:holder_id).group(:holder_id).map(&:holder_id)
    User.order(:surname).find(user_ids)
  end

  def self.holders2
    User.find_by_sql('SELECT users.id, users.name, users.surname FROM funds LEFT JOIN users ON holder_id = users.id WHERE funds.available = 1 GROUP BY holder_id ORDER BY users.surname, users.name')
  end

  def to_s
    name = self.name || ''
    cat  = self.category.name
    cat  = '' if cat == 'Altro'
    cat + ' ' + name
  end

  def to_s_with_holder
    name = self.name || ''
    self.holder.cn_militar + ' - ' + name + ' ' + self.category.name
  end

  def long_description
    self.description.blank? ? self.to_s : self.to_s + ' "' + self.description + '"'
  end
end
