@_4ORMAT_scribeCommandLink = (scribe) ->
  commandName = 'createLink'
  linkCommand = new scribe.api.Command('createLink')

  linkCommand.execute = (options) ->
    scribe.transactionManager.run ->
      unless options.element?
        applyLinkToCurrentSelection(options)

  # if the link structure is changed for any data type, it has to be changed
  # also in the liquid template that renders that type
  applyLinkToElement = (linkType, linkValue, targetBlank, element) ->
    type = element.data("editable-type")
    href = ContentPageEditor.urlFromLinkParams(linkType, linkValue)

    ContentPageEditor.removeLinkFromElement(element)
    element.data('link-type', linkType)
    element.data('link-value', linkValue)
    a = element.find('a:first')
    a.attr('href', href)
    if targetBlank == true
      a.attr('target', '_blank')
    else
      a.removeAttr('target')

  # Apply link to _href_ for current selection
  applyLinkToCurrentSelection = (options) ->
    [linkType, linkValue, targetBlank] = [options.linkType, options.linkValue, options.targetBlank]

    href = urlFromLinkParams(linkType, linkValue)

    # remove any link from the current selection
    removeLinkFromCurrentSelection()
    scribe.options.windowContext.document.execCommand('createLink', false, href)

    # find the newly-created link
    selection = scribe.options.windowContext.getSelection()
    link = $(selection.anchorNode).closest('a')

    # take care of right-to-left selections
    if link.length is 0
      # take care of right-to-left selection dragging
      link = $(selection.focusNode).closest('a')

    link.attr('data-link-type', linkType)
    link.attr('data-link-value', linkValue)

    if targetBlank is true
      link.attr('target', '_blank')
    else
      link.removeAttr('target')

  removeLinkFromCurrentSelection = -> scribe.options.windowContext.document.execCommand('unlink', false, null)

  textIsSelected = -> getSelectedText().length != 0

  getSelectedText = ->
    if scribe.options.windowContext?.selection?
      scribe.options.windowContext.selection.createRange().text
    else if scribe.options.windowContext?
      scribe.options.windowContext.getSelection().toString()

  urlFromLinkParams = (linkType, linkValue) ->
    href = null
    if linkType is 'external'
      href = linkValue
      if !/:\/\//.test(href)
        href = "http://#{href}"
    else if linkType is 'internal'
      href = if /:\/\//.test(linkValue)
        linkValue
      else
        "/#{linkValue}"
    else if linkType is 'mailto'
      href = "mailto:#{linkValue}"
    else
      console.log "Unknown link type #{linkType}"

    href

  scribe.commands[commandName] = linkCommand
