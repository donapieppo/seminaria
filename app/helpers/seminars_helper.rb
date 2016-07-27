module SeminarsHelper
  def css_classes(seminar)
    res = 'seminar'
    res += seminar.past? ? ' past' : ' future'
    res += ' seminar-serial' if seminar.serial_id
    res += ' seminar-cycle'  if seminar.cycle_id
    res
  end

  def where_tag(seminar)
    # lascerei il posto fino a ieri
    # if ! seminar.past?
    if seminar.date > Date.today
      content_tag :div, :class => :where do
        I18n.t(:place) + " " + seminar.place_to_s 
      end
    end
  end

  def abstract_tag(seminar)
    if ! seminar.abstract.blank?  
      content_tag :div, seminar.abstract, :class => 'abstract'
    end
  end
end

