class Registration < ApplicationRecord
  belongs_to :seminar
  belongs_to :user, optional: true

  validates :email, uniqueness: { scope: :seminar_id, message: 'Registrazione già effettuata con questa email.' }

  def self.session_name(seminar)
    "reg_#{seminar.id}"
  end
end
