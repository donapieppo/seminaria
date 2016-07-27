class Fund < ActiveRecord::Base
  belongs_to :category
  belongs_to :holder, class_name: "User", foreign_key: "holder_id"
  has_many   :repayments

  scope :active, -> { where("funds.available = 1") }

  def self.holders
    user_ids = Fund.active.select(:holder_id).group(:holder_id).map { |f| f.holder_id }
    User.order(:surname).find(user_ids)
  end

  def self.holders2
    User.find_by_sql("SELECT users.id, users.name, users.surname FROM funds LEFT JOIN users ON holder_id = users.id WHERE funds.available = 1 GROUP BY holder_id ORDER BY users.surname, users.name")
  end

  def to_s
    name = self.name || ""
    # name + " " + self.category.name
    self.category.name + " " + name
  end

  def to_s_with_holder
    name = self.name || ""
    self.holder.cn_militar + " - " + name + " " + self.category.name
  end
end



