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
      "<i class='far fa-calendar my-2' style='font-size: 24px'></i><br/>".html_safe + 
      "<span class='day-and-month'>#{h nday}<br/>#{h month}</span><br/>".html_safe +
      "<span class='text-muted'>#{h detail}</span> <br/>".html_safe
    end
  end

  def hour_tag(seminar, short: false)
    if seminar.date >= Date.today
      content_tag :div, class: "hour-tag" do
        icon('clock') + "&nbsp;".html_safe + I18n.t(:hours) + " " + I18n.l(seminar.date, format: :hour)
      end
    end
  end

  def where_tag(seminar, short: false)
    # lascerei il posto fino a ieri (prima era if ! seminar.past?)
    if seminar.date >= Date.today
      content_tag :div, class: "where-tag" do
        icon('map-marker-alt') + "&nbsp;".html_safe +
        I18n.t(:place) + " " + seminar.place_to_s 
      end
    end
  end

  def seminar_link_tag(seminar)
    if ! seminar.link.blank?
      txt = seminar.link_text.blank? ? seminar.link : seminar.link_text
      content_tag :div, class: "link-tag" do
        icon('external-link-alt') + "&nbsp;".html_safe + link_to(txt, seminar.link, target: "_blank")
      end
    end
  end

  def clock_tag(seminar, short: false)
    if seminar.date.today? and !short
      content_tag :div, class: :today do 
        concat(big_icon('clock', prefix: 'far')) 
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
      concat(content_tag(:span, icon(:bars, size: 26), class: "actions-button #{(_can_update_seminar or _user_is_holder) ? 'can_update' : ''}"))

      concat(content_tag(:div, class: 'actions-popup') do 
        if ! seminar.past? 
          if _can_update_seminar
            concat( link_to(fwicon('edit') + ' modifica <br/>'.html_safe, edit_seminar_path(seminar) ))
          end
          if _user_is_holder
            repayment_class = (seminar.repayment.fund ? 'fund_ok' : 'fund_missing') 
            concat( link_to(fwicon('euro-sign') + ' scelta del fondo<br/>'.html_safe, choose_fund_repayment_path(seminar.repayment)) )
          end 
          concat ( link_to(fwicon('google', prefix: 'fab') + 'aggiungi a Google Calendar<br/>'.html_safe, seminar.google_url, target: :new) )
          concat ( link_to(fwicon('calendar-plus') + 'aggiungi a iCal<br/>'.html_safe, seminar_url(seminar, format: :ics)) )
        end 
        concat( link_to(fwicon('print') + ' pagina stampabile<br/>'.html_safe, seminar_path(seminar)) )
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

  def repayment_days_warning
    "La richiesta di compenso / rimborso spese deve essere conclusa con <strong>l'autorizzazione del titolare del fondo</strong> almeno 
    <strong>#{Rails.configuration.repayment_deadline} giorni </strong> prima della data di arrivo dell'ospite.".html_safe
  end
end

