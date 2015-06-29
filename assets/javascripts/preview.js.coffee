class @PlatformPreview
  @previews: ->
    selectors = []
    for platform in PlatformBrowser.PLATFORMS
      # dont hide desktop preview
      unless platform is "desktop"
        selectors.push "#cp_preview_" + platform
    $(selectors.join(','))

  constructor: (options) ->
    @platform = options['platform']

  preview: ->
    $('#cp_preview_' + @platform)

  setDeviceColor: (color) =>
    @preview().removeClass("mobile_theme_dark").removeClass("mobile_theme_light").addClass color

  show: =>
    PlatformPreview.previews().hide()
    @preview().show()

  showDeviceTheme: =>
    @preview().addClass('has_mobile_disabled')

  showDeviceTouch: =>
    @preview().removeClass('has_mobile_disabled')
