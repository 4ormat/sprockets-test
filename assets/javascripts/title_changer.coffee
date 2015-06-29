class @TitleChanger
  constructor: ->
    @storeTitle()

  setTitle: (title) ->
    window.document.title = title

  restoreTitle: ->
    window.document.title = @title

  storeTitle: ->
    @title = @currentTitle()

  currentTitle: ->
    window.document.title
