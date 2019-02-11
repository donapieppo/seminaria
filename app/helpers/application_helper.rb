module ApplicationHelper
  def link_to_cv(doc)
    link_to_download(url_for(doc.attach), doc.description) 
    #link_to_download(rails_blob_url(doc.attach, disposition: "attachment"), doc.description) 
  end

  def current_organization
    @current_organization
  end
end
