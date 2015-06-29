@_4ORMAT_scribeUtils =
  rootElements: [
    'DIV'
    'H2'
    'P'
    'UL'
    'LI'
  ]

  _getSelectionContents: (selection) ->
    # Let's select the actionable (with formatBlock) root elements that are currently within selection range.
    # Assuming that we can only reach this function if the current selection
    # does not contain more than one style state, both rawSelectionContents and
    # selectionContents should always contain at most three elements:
    # the start and ending containers and the common ancestor of the start and
    # end containers.
    rawSelectionContents = $(selection.range.startContainer).add([selection.range.endContainer, selection.range.commonAncestorContainer])
    selectionContents = $()
    rawSelectionContents.each((i) ->
      containingNode = if @nodeName is '#text' then @parentNode else @
      containingNode = containingNode.parentNode while window._4ORMAT_scribeUtils.rootElements.indexOf(containingNode.nodeName) is -1
      selectionContents = selectionContents.add($(containingNode))
    )
    selectionContents.not('[data-editable-type]')

  selectionIsContainedByOrOnlyContains: (selection, selector) ->
    selectionIsContainedBySelector = selection.getContaining((node) ->
      $(node).is(selector)
    )

    selectionContents = @_getSelectionContents(selection)
    selectionOnlyContainsSelector = selectionContents.not(selector).length is 0
    !!selectionIsContainedBySelector or selectionOnlyContainsSelector

  toggleClassInSelectionBySelector: (selection, selector, className, toggle) ->
    containingSelector = selection.getContaining((node) ->
      $(node).is(selector)
    )
    return $(containingSelector).toggleClass(className, toggle) if containingSelector?

    selectionContents = @_getSelectionContents(selection)
    selectionContents.filter(selector).toggleClass(className, toggle)

  toggleBRPresenceInSelection: (toggle, selection) ->
    $selectionContents = @_getSelectionContents(selection)
    target = if toggle then 'br' else 'span.format-br-placeholder'
    replacement = if toggle then "<span class='format-br-placeholder'>.</span>" else '<br>'
    $selectionContents.find(target).replaceWith(replacement)

  executeFormatBlockCommand: (scribe, command) ->
    selection = new scribe.api.Selection()
    window._4ORMAT_scribeUtils.toggleBRPresenceInSelection(true, selection)
    command()
    selection = new scribe.api.Selection()
    window._4ORMAT_scribeUtils.toggleBRPresenceInSelection(false, selection)

  buildHeadingCommand: (level) ->
    (scribe) ->
      tag = "<h#{level}>"
      nodeName = "H#{level}"
      commandName = "h#{level}"

      #
      # Chrome: the `heading` command doesn't work. Supported by Firefox only.
      #

      headingCommand = new scribe.api.Command('formatBlock')

      headingCommand.execute = ->
        if @queryState()
          window._4ORMAT_scribeUtils.executeFormatBlockCommand(scribe, =>
            scribe.api.Command::execute.call(@, '<p>')
          )
        else
          window._4ORMAT_scribeUtils.executeFormatBlockCommand(scribe, =>
            scribe.api.Command::execute.call(@, tag)
          )
          selection = new scribe.api.Selection()
          window._4ORMAT_scribeUtils.toggleClassInSelectionBySelector(selection, commandName, 'xl-headline', false) if commandName is 'h2'

      headingCommand.queryState = ->
        selection = new scribe.api.Selection()
        selector = if commandName is 'h2'
          "h2:not(.xl-headline)"
        else
          commandName

        window._4ORMAT_scribeUtils.selectionIsContainedByOrOnlyContains(selection, selector)

      #
      # All: Executing a heading command inside a list element corrupts the markup.
      # Disabling for now.
      #
      headingCommand.queryEnabled = ->
        selection = new scribe.api.Selection()
        containsListNode = $(selection.range.cloneContents())
          .children()
          .filter((i, e) -> e.nodeName is 'OL' or e.nodeName is 'UL' ).length > 0
        listNode = selection.getContaining((node) ->
          node.nodeName is 'OL' or node.nodeName is 'UL'
        )

        scribe.api.Command::queryEnabled.apply(@, arguments) and
        scribe.allowsBlockElements() and
        !listNode and
        !containsListNode

      scribe.commands[commandName] = headingCommand

  formatHTML: (html, fn) ->
    bin = document.createElement('div')
    bin.innerHTML = html
    bin = fn(bin)
    bin.innerHTML

  buildReplaceWithFormatter: (originNode, destinationNode) ->
    (scribe) ->
      replaceOLsWithULs = (node) ->
        $node = $(node)
        $node.find(originNode).replaceWith(->
          $("<#{destinationNode}>").html($(@).contents())
        )
        node

      scribe.registerHTMLFormatter('sanitize', (html) ->
        window._4ORMAT_scribeUtils.formatHTML(html, replaceOLsWithULs)
      )

  recursivelyWalkDOM: (fn, rootNode, scribe) ->
    walk = (parentNode) ->
      treeWalker = scribe.options.windowContext.document.createTreeWalker(parentNode, window.NodeFilter.SHOW_ELEMENT)
      node = treeWalker.firstChild()
      return unless node?
      while true
        fn(node, parentNode)
        walk(node) # recurse
        node = treeWalker.nextSibling()
        break unless node?
      true

    walk(rootNode)

  unwrap: (node, childNode) ->
    node.insertBefore(childNode.childNodes[0], childNode) while childNode.childNodes.length > 0
    node.removeChild(childNode)

  hasMixedStates: (range) ->
    return false unless range?
    $contents = $(range.cloneContents()).children()
    return false unless $contents.length > 1

    $first = $contents.first()
    first = $first[0]
    $rest = $contents.not($first)
    $rest.is (i, el) -> first.nodeName isnt el.nodeName

  includesNodeOfType: ($nodes, nodeName) ->
    nodeName = nodeName.toUpperCase()
    $nodes.is (i, el) -> el.nodeName is nodeName

  elementIsInsideTag: (element, tagName) ->
    $(element).closest(tagName).size() != 0
