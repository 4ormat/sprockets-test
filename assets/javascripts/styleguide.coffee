class @FormatStyleguide
  instance = null

  @get: ->
    instance ?= Styleguide.createInstance()

class Styleguide
  constructor: ->
  @createInstance: ->
    styleguide = new Styleguide()
    styleguide.init()
    styleguide
  init: =>
    @setColorBoxes() if @$colorBox().length
  setColorBoxes: =>
    @$colorBox().each ->
      $(@).children(".color").css("background", $(@).data("color"))
  $colorBox: =>
    $(".colorbox")


$(document).ready ->
  styleGuide = FormatStyleguide.get()
