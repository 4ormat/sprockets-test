@_4ORMAT_scribeCommandToggleBackgroundImageOverlayTextColor = (scribe) ->
  commandName = 'toggleBackgroundImageOverlayTextColor'
  toggleCommand = new scribe.api.Command('formatBlock')

  toggleCommand.execute = ->
    element = $(scribe.el)
    activatedClass = null
    deactivatedClass = null

    scribe.transactionManager.run ->
      # Previously all title templates had light text by default
      if element.find('.color_wrapper').length == 0
        if scribe.options.allowBlockElements
          element.wrapInner("<div class='color_wrapper light_text'></div>")
        else
          element.wrapInner("<span class='color_wrapper light_text'></span>")

      if element.find('.color_wrapper.dark_text').length > 0
        activatedClass = 'light_text'
        deactivatedClass = 'dark_text'
      else
        deactivatedClass = 'light_text'
        activatedClass = 'dark_text'

      element.find('.color_wrapper').removeClass(deactivatedClass).addClass(activatedClass)
      # A hack for buttons as their editable area is inside the button :p
      element.closest('div[data-editable-type]').removeClass(deactivatedClass).addClass(activatedClass)

      updateSelection(element)

  updateSelection = ($el) ->
    selection = new scribe.api.Selection()
    newRange = scribe.options.windowContext.document.createRange()
    colorWrapper = $el.find('.color_wrapper')[0]
    return unless colorWrapper?

    newRange.setStart(colorWrapper, 0)
    newRange.setEnd(colorWrapper, 0)
    selection.selection.removeAllRanges()
    selection.selection.addRange(newRange)

  scribe.commands[commandName] = toggleCommand
