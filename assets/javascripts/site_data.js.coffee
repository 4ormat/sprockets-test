class @SiteData
  instance = null

  @get: ->
    instance ?= DataContainer.create_instance()

  class DataContainer
    constructor: ->
      @siteData = null

    @create_instance: ->
      instance = new DataContainer()
      instance.fetch(null) # prefetch data
      instance

    # fetches /site.json unless already cached, yielding JSON to the callback
    fetch: (callback) =>
      callback ?= ->
        return

      # Only pull if we don't already have it
      if !@siteData
        $.getJSON "/site.json", (data) =>
          @siteData = data
          callback(data)
      else
        callback(@siteData)
