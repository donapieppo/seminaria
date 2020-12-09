class Document < ApplicationRecord
  belongs_to :seminar, optional: true
  belongs_to :repayment, optional: true

  has_one_attached :attach

  def to_s
    self.description.blank? ? self.attach_file_name : self.description
  end
end
