module ApplicationHelper
  def link_to_cv(doc)
    link_to_download(url_for(doc.attach), doc.description) 
  end

  def link_to_id_card(doc)
    link_to_download(url_for(doc.attach), doc.description)
  end
end

include DmUniboCommonHelper

include UserPermissionHelper
include RepaymentChecksHelper
include MoneyHelper
include SeminarsHelper
