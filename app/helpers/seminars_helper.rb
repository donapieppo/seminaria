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
      h(I18n.t(:room)) + " " + h(seminar.room.to_s) + "<br/>".html_safe + h(seminar.room.place.to_s)
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

