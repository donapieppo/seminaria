# in questo proj non si nacondono i files.
# Sono semplici volantini o simili
class Document < ActiveRecord::Base
  belongs_to :seminar, optional: true
  belongs_to :repayment, optional: true
  validates :attach_file_name, uniqueness: { scope: :user_id, message: "File già presente nel database." }

  has_one_attached :attach

  def to_s
    self.description.blank? ? self.attach_file_name : self.description
  end

  def url
    # rails_blob_path(attach, disposition: "attachment")
    # "/seminari" + self.attach
  end
end

