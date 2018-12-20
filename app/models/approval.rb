class Approval < ActiveRecord::Base
  belongs_to :highlight
  belongs_to :user

  # un solo approval a persona a highlight
  validates_uniqueness_of :highlight_id, scope: :user_id, message: "File già presente in database"

  def self.possible_judgments 
    ['yes', 'no', 'boh'] # from database enum
  end

  def to_s
    I18n.t(self.judgment) + " (#{self.justification}) by #{self.user}"  
  end

  def verdict
    case judgment 
    when 'yes' 
      'approvo'
    when  'no'  
      'non approvo'
    when  'boh' 
      'non mi esprimo'
    end
  end
end
