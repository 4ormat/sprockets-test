# hide and show dropdown in nav
unless $(".js_sites_list").children().length
  $(".user_dropdown_wrap").css("min-width", 0)
$('.js_show_sites_list').on "click", (e)->
  e.stopPropagation()
  $('.user_dropdown_wrap').toggle()
  $(".user_dropdown_wrap").css("width", $("#usermenu").outerWidth())
  $(".user_dropdown_wrap").css("height", $(".js_sites_list").outerHeight())
  if $("#usermenu_mask").length
    $('#usermenu_mask').remove()
  else
    $('body').append("<div id='usermenu_mask'></div>")
$('body').on "click", ->
  $('.user_dropdown_wrap').hide()
  $('#usermenu_mask').remove()

$('body').on 'click', '.js_sites_list .dropdown_item', (e) ->
  window.location = $(@).data("href")
