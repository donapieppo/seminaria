# |  1 | onoreficenza  
# |  2 | premio        
# |  3 | pubblicazione 
# |  4 | talk          
class Tag < ActiveRecord::Base
  has_and_belongs_to_many :highlights

  def icon
    case self.name
    when 'onoreficenza'
      'graduation-cap'
    when 'premio'
      'gift'
    when 'pubblicazione'
      'book'
    when 'talk'
      'bullhorn'
    end
  end

  def to_s
    self.name
  end
end
