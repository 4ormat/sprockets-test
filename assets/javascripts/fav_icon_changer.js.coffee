class @FavIconChanger
  constructor: ->
    @$container = $('.site_icon_settings')
    @$input = $('.js_favicon', @$container)
    @$errors = $('.setting_error', @$container)
    @$favicon = $('img.favicon', @$container)
    @$spinner = $('.js_spin_container', @$container)
    @$reset_defaults = $('.js_reset_to_defaults', @$container)
    @url = @$input.attr('data-action')

  start: ->
    @$input.fileupload({
      url: @url
      type: 'PUT',
      dataType: 'json',
      fileInput: @$input,
      progress: null,
      start: @start_upload
      stop: @stop_spinner
      done: (e, data) =>
        icon_source = data.result.icon_url
        @update_icon(icon_source)
        @$reset_defaults.removeClass('disabled')

      fail: (e, data) =>
        message = JSON.parse(data.xhr().response).message
        @show_error(message)
    })

    @$reset_defaults.on 'click', @reset_to_defaults

  start_upload: =>
    @$errors.hide()
    @$favicon.hide()
    @start_spinner()

  update_icon: (src) ->
    @$favicon.attr('src', src).show()

  show_error: (message) ->
    @$errors.text(message || 'Sorry, there was a problem and this icon was not updated. Please try again or contact us at info@format.com.')
    .fadeIn(300)

  reset_to_defaults: =>
    @start_upload()
    $.ajax(
      url: @url,
      data: {fav_icon: 'reset'},
      type: 'PUT'
    ).always(@stop_spinner)
    .done (data) =>
      @update_icon(data.icon_url)
      @$reset_defaults.addClass('disabled')
    .fail (response) =>
      message = response.responseJSON && response.responseJSON.message
      @show_error(message)

  spinner: new Spinner({
    color: '#333',
    width: 2,
    radius: 5,
    length: 2,
  })
  start_spinner: ->
    @spinner.spin(@$spinner[0])
  stop_spinner: =>
    @spinner.stop()
