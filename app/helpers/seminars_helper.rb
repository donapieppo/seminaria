module SeminarsHelper
  def css_classes(seminar)
    res = 'seminar'
    res += seminar.past? ? ' past' : ' future'
    res += ' seminar-serial' if seminar.serial_id
    res += ' seminar-cycle'  if seminar.cycle_id
    res
  end

  # show room unil done
  def where_tag(seminar)
    return unless seminar.room_id
    content_tag :div, class: :where do
      h(I18n.t(:room)) + " " + h(seminar.room.to_s) + " - <em>".html_safe + h(seminar.room.place.to_s) + ".</em>".html_safe
    end
  end

  def committee_tag(seminar)
    content_tag :div, class: :committee do
      h(I18n.t(:organized_by)) + " " + seminar.committee + "<br/>".html_safe + seminar.project 
    end
  end

  def date_tag(seminar, short = nil)
    capture do
      content_tag(:div, class: :date) do
        l(seminar.date, format: (seminar.past? ? :past : :day))
      end +
      content_tag(:div, class: :date) do
        "ore " + 
        (l(seminar.date, format: :hour).html_safe unless (seminar.past? or short))
      end
    end
  end

  def abstract_tag(seminar)
    if ! seminar.abstract.blank?  
      content_tag :div, seminar.abstract, class: 'abstract'
    end
  end

  def started_tag(seminar)
    content_tag(:div, :today) do
      concat big_icon('clock-o') 
      concat( content_tag(:span) do
        (seminar.date < Time.now) ? 'iniziato da ' :  'tra ' +
        time_ago_in_words(seminar.date)
      end )
    end
  end

  def edit_and_delete_tag(seminar)
    if user_owns?(seminar) or user_is_manager?
      link_to_edit(edit_seminar_path(seminar)) + " " + link_to_delete(seminar_path(seminar))
    end
  end

  def fund_tag(seminar)
    if user_is_holder?(seminar)
      repayment_class = (seminar.repayment.fund ? 'fund_ok' : 'fund_missing')
      link_to icon('eur'), choose_fund_repayment_path(seminar.repayment), title: 'Scelta fondo', class: repayment_class
    end
  end

  def actions_tag(seminar) 
    content_tag(:div, :actions) do
      unless seminar.past? 
        concat edit_and_delete_tag(seminar)
        concat fund_tag(seminar)
        concat link_to(fwicon('google'), seminar.google_url, target: :new, title: 'aggiungi a Google Calendar')
        concat link_to(fwicon('calendar'), seminar_url(seminar, format: :ics), title: 'aggiungi a iCal')
      end
      concat link_to(fwicon('print'), seminar_path(seminar), title: I18n.t(:printable_page))
    end
  end

  def minutes_collection
    [30,45,60,75,90,120,180].map do |p|
      [p.to_s + " " + I18n.t(:minutes), p] 
    end
  end

  def place_and_room_json_hash
    res = Room.select(:id, :place_id).inject({}) {|res, room| res[room.place_id] ||= []; res[room.place_id] << room.id; res}
    res[0] = [nil]
    res.to_json
  end
end

