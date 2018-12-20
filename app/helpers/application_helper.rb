module ApplicationHelper
  def true_false_to_s(str)
    if str === true
      "si" 
    elsif str === false 
      "no" 
    else 
      str
    end
  end

  def link_to_cv(doc)
    link_to_download(doc.url, doc.description) 
  end
end
