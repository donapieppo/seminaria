# in questo proj non si nacondono i files.
# Sono semplici volantini o simili
class Document < ActiveRecord::Base
  belongs_to :seminar, optional: true
  belongs_to :repayment, optional: true
  validates :attach_file_name, uniqueness: { scope: :user_id, message: "File già presente nel database." }

  has_attached_file :attach

  validates_attachment_presence :attach
  do_not_validate_attachment_file_type :attach

  def to_s
    self.description.blank? ? self.attach_file_name : self.description
  end

  def url
    "/seminari" + self.attach.url
  end
end

