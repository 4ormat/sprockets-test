class @Tooltips
  instance = null
  @get: ->
    instance ?= FormatTooltips.createInstance()

  class FormatTooltips
    constructor: () ->
      @_transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd otransitionend'
      @TOOLTIP_OFFSET = 3
      @TOOLTIP_ARROW_HEIGHT = 3

    @createInstance: ->
      tooltips = new FormatTooltips()
      tooltips.init()
      tooltips

    init: =>
      @bindEvents()

    bindEvents: =>
      @$body().on "mouseenter", "[data-tooltip]", (e) =>
        @$tooltip().remove()
        @attachTooltipToElement( $(e.currentTarget) )
      @$body().on "mouseleave", "[data-tooltip]", =>
        @removeTooltip()


    attachTooltipToElement: ($el, text = "") =>
      text = $el.data "tooltip" unless text
      alignment = $el.data "tooltip-align"
      unless alignment?
        alignment = "center"
      delay = $el.data "tooltip-delay"
      unless delay?
        delay = 1

      @$body().append(@$tpl(text, alignment))
      @setTooltipPosition($el, alignment)
      @showTooltip(delay)

    setTooltipPosition: ($el, alignment) =>
      if alignment is "left"
        x = $el.offset().left - 4
      else if alignment is "right"
        x = $el.offset().left + ($el.outerWidth() - @$tooltip().outerWidth()) + 4
      else
        x = $el.offset().left - ((@$tooltip().outerWidth() - $el.outerWidth()) * 0.5)

      # Stupid Hack™

      y = $el.offset().top - (@$tooltip().outerHeight() + @TOOLTIP_ARROW_HEIGHT + @TOOLTIP_OFFSET + @$body().offset().top)
      if y < @$body().offset().top
        @$tooltip().addClass("tooltip-below")
        y = ($el.offset().top + $el.outerHeight() + @TOOLTIP_ARROW_HEIGHT + @TOOLTIP_OFFSET) - @$body().offset().top

      @$tooltip().css
        top: parseInt(y, 10) + "px"
        left: parseInt(x, 10) + "px"


    showTooltip: (delay) =>
      setTimeout =>
        @$tooltip().addClass "active"
      , delay

    removeTooltip: =>
      @$tooltip().removeClass("active").on @_transitionEnd, =>
        @$tooltip().remove()

    $tpl: (text, alignment) =>
      "<div class='f-tooltip tooltip-#{alignment}'>#{text}</div>"

    $body: =>
      $("body")

    $tooltip: =>
      $(".f-tooltip")

$(document).ready ->
  tooltips = Tooltips.get()
