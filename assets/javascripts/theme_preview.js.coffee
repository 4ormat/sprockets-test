class @ThemePreview
  instance = null

  @get: ->
    instance ?= Preview.createInstance()

  class Preview
    constructor: ->
      @name = null
      @defaultConfigId = null
      @previewUrl = null
      @availableConfigs = null
      @browser = null
      @baseUrl = '/site/design/preview'
      @routes = ThemeEditorRoutes.get()

    @createInstance: ->
      preview = new Preview()
      preview.bindControls()
      preview.routes.add(preview.baseUrl, preview.show, {unload: preview.hide})
      preview

    setBrowser: (browser) ->
      @browser = browser

    bindControls: =>
      @closeButton().on 'click', (event) =>
        event.preventDefault()
        @routes.previousOrHome()

      $('ul.skins').on 'click', 'li', (event) =>
        event.stopPropagation()
        target = $(event.currentTarget)
        target.addClass('is_active').siblings('li').removeClass('is_active');
        @skinSelect().data('value', String(target.data('value')))
        @previewSelectedSkin()


      @tryNowButton().on 'click', (event) =>
        event.preventDefault()
        window.location = @themeTryUrl()

    closeButton: =>
      @overlay().find('.close_theme_preview ')

    controls: =>
      @overlay().find('.controls')

    setTheme: (theme) =>
      @name = theme.name
      @defaultConfigId = theme.configId
      @availableConfigs = theme.availableConfigs
      @previewUrl = theme.previewUrl

      @loadPreview(@previewUrl)
      @populateAvailableConfigs()

    show: (ctx, next, options) =>
      data = @browser.getThemeDataBySlug(ctx?.params?.theme ? '')
      @setTheme(data)
      @overlay().show().addClass('visible')

    hide: =>
      @skinsDropdown().removeClass('active')
      @frame()[0].contentWindow.location.replace('about:blank')
      overlay = @overlay().removeClass('visible')

    # In order to prevent the iframe from pushing another history entry on to
    # the history stack. See http://stackoverflow.com/questions/821359/reload-an-iframe-without-adding-to-the-history
    # for more information.
    loadPreview: (url) =>
      return if @frame()[0].contentWindow.location.href is url # don't refresh if already loaded
      @frame()[0].contentWindow.location.replace(url)

    overlay: ->
      $('#theme_preview_overlay')

    frame: =>
      @overlay().find('iframe')

    populateAvailableConfigs: =>
      if Object.keys(@availableConfigs).length < 2
        @skinSelector().hide()
        return

      @skinSelect().children('li').remove()

      i = 1

      order = Object.keys(@availableConfigs).sort()

      for id in order
        attr = @availableConfigs[id]
        option = $('<li />')
        option.attr('data-preview-url', attr['preview-url'])
        option.attr('data-value', id)
        option.addClass('is_active') if id == String(@defaultConfigId)

        @skinSelect().append(option)
        # set names for each to be 1,2,3...
        @skinSelect().children('li').last().text(i)
        @skinSelect().attr('data-value', String(@defaultConfigId))
        i += 1

      @skinSelector().show()

    previewSelectedSkin: =>
      return unless @selectedSkin()
      @loadPreview(@selectedSkin().data('preview-url'))

    selectedSkin: =>
      return null unless @skinSelector().is(":visible")
      id = @skinSelect().data('value')
      @skinSelect().find("li[data-value=#{id}]").first()


    selectedSkinId: =>
      @selectedSkin() && @selectedSkin().data('value')

    selectedSkinName: =>
      @selectedSkin().text()

    skinSelect: =>
      @overlay().find('ul.skins')

    skinSelector: =>
      @overlay().find('.skin_selector')

    skinsDropdown: =>
      @skinSelector().find('.skin_dropdown')

    themeTryUrl: =>
      window.location.origin + "/site/design?id=" + (@selectedSkinId() || @defaultConfigId)

    tryNowButton: =>
      @overlay().find('.try_now')

    visible: =>
      @overlay().is(':visible')
