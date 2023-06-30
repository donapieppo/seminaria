module SeminarsHelper
  def css_classes(seminar)
    res = "seminar"
    res += seminar.past? ? " past" : " future"
    res += " seminar-serial" if seminar.serial_id
    res += " seminar-cycle" if seminar.cycle_id
    res += " seminar-conference" if seminar.conference_id
    res
  end

  def seminar_link_tag(seminar)
    if !seminar.link.blank?
      txt = seminar.link_text.blank? ? seminar.link : seminar.link_text
      content_tag :div, class: "link-tag" do
        dm_icon("external-link-alt", fw: true) + "&nbsp;".html_safe + link_to(txt, seminar.link, target: "_blank")
      end
    end
  end

  def document_tag(document, short: false)
    if document.attach.attached?
      content_tag :div do
        link_to url_for(document.attach) do
          dm_icon("download") + "&nbsp;&nbsp;".html_safe + (document.description.blank? ? 'scarica allegato' : document.description)
        end
      end
    end
  end

  def abstract_tag(seminar)
    if !seminar.abstract.blank?  
      content_tag :div, seminar.abstract, class: 'abstract'
    end
  end

  def arguments_tag(seminar)
    a = seminar.arguments
    a.empty? and return ""
    content_tag :p do
      if a.first.name == 'interdisciplinare'
        "seminario interdisciplinare"
      else
        "seminario di " + a.to_a.join(", ")
      end
    end
  end

  def repayment_days_warning(seminar = nil)
    if seminar && seminar.on_line
      "La richiesta di compenso / rimborso spese deve essere conclusa con <strong>l'autorizzazione del titolare del fondo</strong> almeno 
      <strong>#{Rails.configuration.on_line_repayment_deadline_1} giorni </strong> prima della seduta della Giunta; tra la seduta e l’iniziativa sono necessari <strong>#{Rails.configuration.on_line_repayment_deadline_2} giorni</strong> per l’espletamento delle pratiche.".html_safe
    else
      "La richiesta di compenso / rimborso spese deve essere conclusa con <strong>l'autorizzazione del titolare del fondo</strong> almeno 
      <strong>#{Rails.configuration.repayment_deadline} giorni </strong> prima della data di arrivo dell'ospite.".html_safe
    end
  end
end
