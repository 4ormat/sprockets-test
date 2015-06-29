class @PagesData
  instance = null

  @get: ->
    instance ?= DataContainer.create_instance()

  class DataContainer
    constructor: ->
      @pagesData = {}

    @create_instance: ->
      new DataContainer()

    # fetches /pages/:id.json unless already cached, yielding JSON to the callback
    fetch: (id, callback) =>
      callback ?= ->
        return

      # Only pull if we don't already have it
      if !@pagesData[id]
        $.getJSON "/pages/#{id}.json", (data) =>
          @pagesData[id] = data
          callback(data)
      else
        callback(@pagesData[id])
