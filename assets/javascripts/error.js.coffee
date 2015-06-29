class @ContentPageEditorError
  constructor: (json) ->
    @type = json['type']
    @message = json['message']

  isImageLimitError: =>
    @type == "asset_image_limit"
