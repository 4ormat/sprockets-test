class @Previewer
  init: ->
    @editor = ContentPageEditor.get()
    @bindEvents()

  bindEvents: =>
    @overlay().find('.close_preview').on 'click', (e) =>
      e.stopPropagation()
      @hide()

  promoteElement: =>
    $el = @overlay().detach()
    $(document.body).append($el)

  frame: =>
    @overlay().find('iframe')

  hideControls: =>
    @overlay().find('.controls').hide()

  loadFrame: =>
    console.log "ERROR: need to overwrite frame loader in subclass"

  show: =>
    @hideControls()
    loading = @loadFrame()
    if loading? and loading.done?
      @overlay().addClass('previewer-loading')
      loading.done( =>
        @overlay().removeClass('previewer-loading')
        doc = @frame()[0].contentDocument
        body = $($(doc).find('body'))
        body.bind 'click', (e) ->
          e.preventDefault()

        win = @frame()[0].contentWindow

        # reset any form buttons that may have timed out
        if win._4ORMAT.contact_forms
          for contactFormId in win._4ORMAT.contact_forms
            form = win._4ORMAT.$('#' + contactFormId)
            submit = form.find('input[type=submit]')

            label = $.trim($(submit).siblings('._4ORMAT_module_contact_label').text())
            if label == ""
              label = form.find('input[type=submit]').attr('originalValue')
            submit.val(label)

      )
    @showControls()
    @overlay().show()

  hide: =>
    @overlay().hide()

  showControls: =>
    @controls().show()

  overlay: ->
    $('#content_page_preview_overlay')
