$('.interface_dropdown_noselect2').on "click", (e) ->
  e.stopPropagation()
  $(@).children('.interface_dropdown_button, .interface_dropdown_list').toggleClass('is_open')
  if($(@).parents('.sidebar_new_page').length)
    $(@).parents('.sidebar_new_page').toggleClass('overflow_hack')

$('html').on "click", ->
  $('.interface_dropdown_button, .interface_dropdown_list').removeClass('is_open')    
  if($('.interface_dropdown_noselect2').parents('.sidebar_new_page').length)
    $('.interface_dropdown_noselect2').parents('.sidebar_new_page').removeClass('overflow_hack')