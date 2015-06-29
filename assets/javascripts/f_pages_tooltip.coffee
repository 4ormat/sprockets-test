pages_tooltip = window.pages_tooltip = {}
transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd otransitionend'
pages_tooltip.tpl = "<div class='toolbar_item_tooltip'></div>"
$("body").on "mouseenter", "[data-f-page-tooltip]", ->
  target = $(@)
  $tooltip = $("<div class='toolbar_item_tooltip'>#{target.attr("data-f-page-tooltip")}</div>")
  $('body').append($tooltip)
  top = target.offset().top - $tooltip.outerHeight() - 10
  left = target.offset().left - (($tooltip.outerWidth() - target.outerWidth()) * 0.5)
  $tooltip.css
    'top': top
    'left': left
  setTimeout ->
    $tooltip.addClass('active')
  , 0
$("body").on "mouseleave", "[data-f-page-tooltip]", ->
  $('.toolbar_item_tooltip').removeClass('active').on transitionEnd, ->
    $(@).off transitionEnd
    $(@).remove()

