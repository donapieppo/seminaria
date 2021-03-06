module SeminarsHelper
  def css_classes(seminar)
    res = 'seminar'
    res += seminar.past? ? ' past' : ' future'
    res += ' seminar-serial' if seminar.serial_id
    res += ' seminar-cycle'  if seminar.cycle_id
    res
  end

  def day_tag(seminar, short: false)
    month  = I18n.l(seminar.date, format: :month)
    nday   = I18n.l(seminar.date, format: :nday)
    detail = seminar.past? ? seminar.date.year : I18n.l(seminar.date, format: :wday) # week day for future seminar or year if already done

    content_tag :div, class: 'date' do
      "<i class='fas fa-calendar my-2' style='font-size: 24px'></i><br/>".html_safe + 
        "<span class='day-and-month'>#{h nday}<br/>#{h month}</span><br/>".html_safe +
        "<span class='text-muted'>#{h detail}</span> <br/>".html_safe
    end
  end

  def hour_tag(seminar, short: false)
    content_tag :div, class: "hour-tag" do
      dmicon('clock') + "&nbsp;".html_safe + I18n.t(:hours) + " " + I18n.l(seminar.date, format: :hour)
    end
  end

  def on_line_where_url(seminar) 
    if seminar.meeting_visible
      if seminar.zoom_meeting
        link_to('collegamento al meeting su zoom', seminar.zoom_meeting.join_url)
      else
        (seminar.meeting_code.blank? ? "" : ("codice: (" + h(seminar.meeting_code) + ") - ")) + 
        (seminar.meeting_url.blank?  ? "" : link_to('collegamento al meeting', seminar.meeting_url))
      end
    else
      "l'indirizzo con cui accedere verrà inviato via mail agli iscritti il giorno del seminario."
    end
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
        dmicon('download') + "&nbsp;".html_safe + link_to(document.description, url_for(document.attach))
      end
    end
  end

  def clock_tag(seminar, short: false)
    if seminar.date.today? and !short
      content_tag :div, class: :today do 
        concat(big_dmicon('clock')) 
        concat( 
               content_tag(:span, class: 'ml-2') do
                 ((seminar.date < Time.now) ? 'iniziato da ' :  'tra ') + time_ago_in_words(seminar.date) 
               end
              )
      end 
    end 
  end 

  def abstract_tag(seminar)
    if ! seminar.abstract.blank?  
      content_tag :div, seminar.abstract, class: 'abstract'
    end
  end

  def actions_tag(seminar)
    _can_update_seminar = policy(seminar).update? 
    _user_is_holder     = user_is_holder?(seminar)
    capture do 
      concat(content_tag(:span, dmicon(:bars, size: 26), class: "actions-button #{(_can_update_seminar or _user_is_holder) ? 'can_update' : ''}"))

      concat(content_tag(:div, class: 'actions-popup') do 
        if ! seminar.past? 
          if _can_update_seminar
            concat( link_to(fwdmicon('edit') + ' modifica<br/>'.html_safe, edit_seminar_path(seminar) ))
            if seminar.on_line
              concat( link_to(fwdmicon('user-check') + ' iscrizioni<br/>'.html_safe, seminar_registrations_path(seminar) ))
            end
          end
          if _user_is_holder
            repayment_class = (seminar.repayment.fund ? 'fund_ok' : 'fund_missing') 
            concat( link_to(fwdmicon('euro-sign') + ' scelta del fondo<br/>'.html_safe, choose_fund_repayment_path(seminar.repayment)) )
          end 
          concat ( link_to(fwdmicon('google', prefix: 'fab') + 'aggiungi a Google Calendar<br/>'.html_safe, seminar.google_url(seminar_url(seminar)), target: :new) )
          concat ( link_to(fwdmicon('calendar-plus') + 'aggiungi a iCal<br/>'.html_safe, seminar_url(seminar, format: :ics)) )
        end 

        concat( link_to(fwdmicon('print') + ' pagina stampabile<br/>'.html_safe, seminar_path(seminar)) )

        if policy(seminar).destroy?
          concat( '<br/>'.html_safe + link_to_delete('elimina', seminar_path(seminar)) )
        end 
      end)
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

