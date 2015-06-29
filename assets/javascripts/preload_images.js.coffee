window.APP.preload_images = (imgs) ->
  $(imgs).each (index, value) ->
     image = new Image()
     image.src = this