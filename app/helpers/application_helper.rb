include DmUniboCommonHelper

module ApplicationHelper
  def link_to_cv(doc)
    link_to_download(url_for(doc.attach), doc.description) 
  end

  def link_to_id_card(doc)
    link_to_download(url_for(doc.attach), doc.description)
  end

  def current_organization
    @current_organization
  end
end

