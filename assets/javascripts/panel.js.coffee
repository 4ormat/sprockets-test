class @PlatformPanel
  instance = null

  @get: ->
    instance ?= Panel.createInstance()

  @panels: ->
    selectors = []
    for platform in PlatformBrowser.PLATFORMS
      selectors.push "#cp_panel_#{platform}"
    $(selectors.join(','))


  class Panel
    constructor: ->
      @platformBrowser = null
      @activePanel = null
      @mobileThemeSettings = MobileThemeSettings.get()
      @tabletThemeSettings = TabletThemeSettings.get()

    @createInstance: ->
      panel = new Panel()
      panel

    isDirty: =>
      return false if !@activePanel
      @activePanel.data('dirty')

    markClean: =>
      @activePanel.data('dirty', false)

    panel: (platform) ->
      $("#cp_panel_#{platform}")

    setPanel: (panel) =>
      PlatformPanel.panels().hide()
      @activePanel = panel
      @markClean()
      panel.show()

    show: (platform) =>
      panel = @panel(platform)
      @setPanel(panel)
