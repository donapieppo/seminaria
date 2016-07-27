description_field = ->
  $("#seminar_place_id option:selected").each ->
    if ($(this).val() == "2")
      $(".seminar_place_description").show('slow')
    else
      $(".seminar_place_description").hide('fast')
  
$ ->
  $("input.datetime_picker").datetimepicker(minuteStepping: 15)
  $(".abstract").jTruncate(moreText: "[vedi tutto]", lessText: "[comprimi]");

  description_field()
  $("#seminar_place_id").change ->
    description_field()


#  $(".abstract").each -> 
#    limit = 100
#    all = $(this).text()
#    console.log(all.length)
#    if all.length > 100 
#      short = all.substr(0,100)
#      $(this).html("<span class='short'>" + short + "</span>" + "<span class='long'>" + all + "</span> <a class='show'>[...]></a>")
#  $(".long").hide()
#  $(".show").click ->
#    $(this).parent().find(".long").toggle() 
#    $(this).parent().find(".short").toggle() 

# Choosing Place 
# app/views/seminars/_form.html.erb

