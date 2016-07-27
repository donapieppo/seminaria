# ricorda che siamo con ActiveSupport::TimeWithZone
module Calendar
  Time::DATE_FORMATS[:google] = "%Y%m%dT%H%M%SZ"

  def calendar_start_date
    self.date.gmtime.to_s(:google)
  end

  def calendar_end_date
    # FIXME need duration, decide if required
    (self.date + (self.duration ? self.duration.minutes : 60)).gmtime.to_s(:google)
  end

  # action(required)  This value is always TEMPLATE (all capitalized).  action=TEMPLATE
  # text(required)
  # dates(required) Date and time of the event, in UTC format. 
  #    Append a capitalized letter “Z” to the end of times. 
  #    Google Calendar will interpret the date and time for the user’s time zone.
  # sprop(required) Information to identify your organization, like your website address
  #    sprop=website:www.dm.unibo.it
  # details
  # location
  #
  # http://support.google.com/calendar/bin/answer.py?hl=en&answer=2476685
  # http://www.google.com/calendar/images/ext/gc_button1.gif
  # in ruby 1.9 .getlocal("+01:00")
  def google_url
    google_url = "http://www.google.com/calendar"
    title      = self.title 
    speaker    = self.speaker
    where      = self.place_to_s
    url        = %Q{https://www.dm.unibo.it/seminari/seminars/#{self.id}}
    %Q(#{google_url}/event?action=TEMPLATE&text=Seminario #{speaker}: #{title}&details=#{url}&dates=#{self.calendar_start_date}/#{self.calendar_end_date}&location=#{where}&trp=false&sprop=website:www.dm.unibo.it)
  end

end

#  begin     = mktime($row['ora_h'], $row['ora_m'], 0, $row['data_m'], $row['data_g'], $row['data_a']) - 1 * 60 * 60 ;
#  $end       = $begin + 60 * $row['durata'];
#
#  # versione corretta
#  # da aggiungere a http://www.php.net/manual/en/datetime.add.php
#  # $begin = new DateTime($row['data_a']."-".$row['data_m']."-".$row['data_g']." ".$row['ora_h'].":".$row['ora_m'], new DateTimeZone('Europe/Rome'));
#
#  $gfrom     = date('Ymd\THis\Z', $begin); # 20100202T083000Z
#  $gto       = date('Ymd\THis\Z', $end);   # 20100202T083000Z
#  $gtitolo   = urlencode("Seminario " . $row['relatore'] . " - " . $row['titolo']);
#  # $gdetails  = urlencode(substr($row['abstract'], 0, 500));
#  $gdetails  = urlencode($row['abstract']);
#  $glocation = urlencode("Dipartimento di Matematica: " . $row['room_name']);
#
#<a href="http://www.google.com/calendar/event?action=TEMPLATE&text=<?= $gtitolo ?>&dates=<?= $gfrom ?>/<?= $gto ?>&details=<?= $gdetails ?>&location=<?= $glocation ?>&trp=false&sprop=&sprop=name:" target="_blank"><img src="images/gc_button1.gif" border=0></a>

