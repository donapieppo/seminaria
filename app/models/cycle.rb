class Cycle < ActiveRecord::Base
  belongs_to :user
  has_many :seminars

  validates_presence_of :title, :committee

  def to_s
    self.title
  end
end

