module SeminarsHelper
  def css_classes(seminar)
    res = 'seminar'
    res += seminar.past? ? ' past' : ' future'
    res += ' seminar-serial' if seminar.serial_id
    res += ' seminar-cycle'  if seminar.cycle_id
    res
  end

  def when_tag(seminar, past: false, short: false)
    date = I18n.l(seminar.date, format: (seminar.past? ? :past : :day))
    hour = I18n.l(seminar.date, format: :hour)

    content_tag :div, class: 'date' do
      icon('calendar').html_safe + '<br/>'.html_safe
      date.html_safe + ((past or short) ? '' : "<br/>ore #{hour}".html_safe)
    end
  end

  def where_tag(seminar, past: false, short: false)
    # lascerei il posto fino a ieri (prima era if ! seminar.past?)
    if seminar.date > Date.today
      content_tag :div, class: :where do
        #icon('map-marker') +
        I18n.t(:place) + " " + seminar.place_to_s 
      end
    end
  end

  def clock_tag(seminar, short: false)
    if seminar.date.today? and !short
      content_tag :div, class: :today do 
        concat(big_icon('clock', prefix: 'far'))
        concat( 
          content_tag(:span) do
            ((seminar.date < Time.now) ? 'iniziato da ' :  'tra ') + time_ago_in_words(seminar.date) 
          end
        )
      end 
    end 
  end 

  def arguments_tag(seminar)
    content_tag :div, seminar.arguments_string 
  end

  def abstract_tag(seminar)
    if ! seminar.abstract.blank?  
      content_tag :div, seminar.abstract, class: 'abstract'
    end
  end

  def repayment_days_warning
    "La richiesta di compenso / rimborso spese deve essere conclusa con <strong>l'autorizzazione del titolare del fondo</strong> almeno 
    <strong>#{Rails.configuration.repayment_deadline} giorni </strong> prima della data di arrivo dell'ospite.".html_safe
  end
end

