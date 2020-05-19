class Registration < ApplicationRecord
  belongs_to :seminar
  belongs_to :user, optional: true

  def self.session_name(seminar)
    "reg_#{seminar.id}"
  end
end
