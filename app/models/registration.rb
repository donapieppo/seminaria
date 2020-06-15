class Registration < ApplicationRecord
  belongs_to :seminar
  belongs_to :user, optional: true

  validates :email, uniqueness: { message: 'Registrazione già effettuata con questa email.' }

  def self.session_name(seminar)
    "reg_#{seminar.id}"
  end
end
