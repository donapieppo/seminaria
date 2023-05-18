module SeminarsHelper
  def css_classes(seminar)
    res = 'seminar'
    res += seminar.past? ? ' past' : ' future'
    res += ' seminar-serial'     if seminar.serial_id
    res += ' seminar-cycle'      if seminar.cycle_id
    res += ' seminar-conference' if seminar.conference_id
    res
  end

  def hour_tag(seminar, short: false)
    return '' if seminar.conference_id
    content_tag :div, class: "hour-tag" do
      dmicon('clock') + "&nbsp;".html_safe + I18n.t(:hours) + " " + I18n.l(seminar.date, format: :hour)
    end
  end

  def on_line_where_url(seminar) 
    #if seminar.meeting_visible
      if seminar.zoom_meeting
        link_to('collegamento al meeting su zoom', seminar.zoom_meeting.join_url)
      else
        (seminar.meeting_code.blank? ? "" : ("codice: (" + h(seminar.meeting_code) + ") - ")) + 
        (seminar.meeting_url.blank?  ? "" : link_to('collegamento al meeting', seminar.meeting_url))
      end
    #else
    #  "l'indirizzo con cui accedere verrà inviato via mail agli iscritti il giorno del seminario."
    #end
  end

  def where_tag(seminar, short: false)
    # lascerei il posto fino a ieri (prima era if ! seminar.past?)
    content_tag(:div, class: "where-tag") do
      if seminar.in_presence
        dmicon('map-marker-alt') + "&nbsp;".html_safe + " " + seminar.place_to_s 
      end
    end +
    content_tag(:div, class: "where-tag") do
      if seminar.on_line
        dmicon('cloud') + " seminario on line • " + on_line_where_url(seminar).html_safe
      end
    end
  end

  def seminar_link_tag(seminar)
    if ! seminar.link.blank?
      txt = seminar.link_text.blank? ? seminar.link : seminar.link_text
      content_tag :div, class: "link-tag" do
        dmicon('external-link-alt') + "&nbsp;".html_safe + link_to(txt, seminar.link, target: "_blank")
      end
    end
  end

  def document_tag(document, short: false)
    if document.attach.attached?
      content_tag :div do
        link_to(dmicon('download') + "&nbsp;".html_safe + document.description, url_for(document.attach))
      end
    end
  end

  def abstract_tag(seminar)
    if ! seminar.abstract.blank?  
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

  def repayment_days_warning(seminar=nil)
    if seminar && seminar.on_line
      "La richiesta di compenso / rimborso spese deve essere conclusa con <strong>l'autorizzazione del titolare del fondo</strong> almeno 
      <strong>#{Rails.configuration.on_line_repayment_deadline_1} giorni </strong> prima della seduta della Giunta; tra la seduta e l’iniziativa sono necessari <strong>#{Rails.configuration.on_line_repayment_deadline_2} giorni</strong> per l’espletamento delle pratiche.".html_safe
    else
      "La richiesta di compenso / rimborso spese deve essere conclusa con <strong>l'autorizzazione del titolare del fondo</strong> almeno 
      <strong>#{Rails.configuration.repayment_deadline} giorni </strong> prima della data di arrivo dell'ospite.".html_safe
    end
  end

  # OLD 
  def on_line_tag(seminar)
    if seminar.on_line  
      if session[Registration.session_name(seminar)]
        content_tag :div, class: "registration-link float-right text-success mt-3" do
          dmicon("check-square") + ' registrato (verranno inviate istruzioni per partecipare il giorno del seminario)'
        end
      elsif r = current_user ? current_user.registration(seminar) : nil
        content_tag :div, class: "registration-link float-right text-success mt-3" do
          'Registrato (verranno inviate istruzioni per partecipare il giorno del seminario) '.html_safe + 
            link_to(dmicon('trash'), registration_path(r), method: :delete, title: 'Cancella la registrazione')
        end
      elsif ! (current_user && current_user.owns?(seminar)) 
        content_tag :div, class: "registration-link float-right mt-3" do
          link_to t(:register_and_be_notified), new_seminar_registration_path(seminar), class: 'btn btn-primary' 
        end
      end
    end
  end
end

