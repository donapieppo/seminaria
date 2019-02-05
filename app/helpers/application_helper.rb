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
    link_to_download(url_for(doc.attach), doc.description) 
    #link_to_download(rails_blob_url(doc.attach, disposition: "attachment"), doc.description) 
  end
end
