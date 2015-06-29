class @ImageVariables

  instance = null

  @get: ->
    instance ?= Variables.createInstance()

  class Variables
    constructor: ->
      @customizerPanel = null

    @createInstance: ->
      variables = new Variables()
      variables.bindControls()
      variables

    imageFieldSelector: ->
      "input[name=theme_variable\\[value\\]], input[name=menu_title_image_ipad_value\\[resource\\]], input[name=menu_title_image_mobile_value\\[resource\\]]"

    imageRows: =>
      $(@imageRowsSelector())

    imageRowsSelector: ->
      '.cp_attribox_row[data-variable-type=image]'

    bindControls: ->
      $(".cp_accessory_image").click (e) ->
        e.preventDefault()
        $(e.target).parent().find("form .hidden_file").trigger "click"

      # delete button
      @imageRows().on "click", ".image_delete_overlay", (e) =>
        context = $(e.target).closest(@imageRowsSelector())
        @imageVariableRemove(context)

      @imageRows().each (i, element) => @initImageRow($(element))

    hideImageVariableThumbnail: (context) =>
      button = context.find(".cp_accessory_image")
      button.prev(".thumb_container").fadeOut 300
      button.next(".cp_accessory_image_progress_container").hide()
      @setImageVariableProgress(0.0, context)
      button.text "Add"
      button.removeClass "active"
      button.css "pointer-events", "auto"

    imageVariableImageSelected: (e, data) =>
      $addButton = data.context.find(".cp_accessory_image")
      $addButton.css "pointer-events", "none"
      fileArray = data
      if fileArray.files and fileArray.files[0]
        #Check support in case of older versions of Chrome (13 or below) or Safari (5.1 and below)
        if window.FileReader
          reader = new FileReader()
          reader.onload = (ev) ->
            $addButton.addClass "active"
            $addButton.prev().children(".cp_accessory_image_thumb").attr "src", ev.target.result
            $addButton.prev().show()
            $addButton.next(".cp_accessory_image_progress_container").fadeIn 300
            jqXHR = data.submit()
          reader.readAsDataURL fileArray.files[0]

        else
          $addButton.addClass "active"
          $addButton.next(".cp_accessory_image_progress_container").fadeIn 300
          jqXHR = data.submit()
      else
        console.log "Files do not exist"

    imageVariableProgress: (e, data) =>
      percent = parseInt(data.loaded / data.total, 10)
      @setImageVariableProgress(percent, data.context)

    imageVariableRemove: (context) =>
      value_field = context.find(@imageFieldSelector())
      value_field.data("thumbnailUrl", null)
      value_field.val("").trigger "change"

      @hideImageVariableThumbnail(context)
      @customizerPanel.variableChanged(value_field) unless value_field.data('immediateUpload')

    imageVariableUploadComplete: (e, data) =>
      data.jqXHR.done (response) =>
        value_field = data.context.find(@imageFieldSelector())
        value_field.data("thumbnailUrl", response.theme_variable_image.vfs_file.thumbnails["200x200"].src)

        data.context.find('button').blur()

        @customizerPanel.variableChanged(value_field, data.context.data('noReload') != 'yes')
        value_field.val(response.theme_variable_image.id).trigger "change"

        @showImageVariableThumbnail(data.context)

    imageVariableUploadFailed: (e, data) =>
      @hideImageVariableThumbnail(data.context)
      msg = "There was a problem uploading your image"
      try
        msg = msg + ": " + JSON.parse(data.jqXHR.responseText)["error"]
      catch err
        msg = msg + "."
      msg = msg + " Please try again with another image or email us at <a href='mailto:info@format.com'>info@format.com</a> for assistance."
      modal = new ModalMessage(
        title: "Your image was not saved"
        modal_class: "medium center warning"
        html: msg
        buttons:
          close:
            text: "Close"
            classes: "btn_default"
      )

    initImageRow: (element) =>
      value_field = element.find(@imageFieldSelector())
      form = element.find("form")
      form.fileupload
        url: form.attr("action")
        sequentialUploads: true
        multipart: true
        dataType: "json"
        add: (e, data) =>
          data.context = element
          @imageVariableImageSelected(e, data)
        progress: (e, data) => @imageVariableProgress(e, data)
        done: (e, data) => @imageVariableUploadComplete(e, data)
        fail: (e, data) => @imageVariableUploadFailed(e, data)

      if "thumbnailUrl" of value_field.data()
        thumb = element.find(".cp_accessory_image_thumb")
        button = element.find(".cp_accessory_image")
        thumb.attr("src", value_field.data("thumbnailUrl")).parent().show()
        button.addClass("active").text "Replace"

    setImageVariableProgress: (percent, context) =>
      progressBar = context.find(".cp_accessory_image_progress")

      # 4px == 0, 48 px wide == 100%
      px = Math.floor(33 * percent) + "px"
      progressBar.css "width", px

    # expects the thumbnail url to be on the theme_variable[value] field's
    # data('thumbnailUrl')
    showImageVariableThumbnail: (context) =>
      progressBar = context.find(".cp_accessory_image_progress_container")
      value_field = context.find(@imageFieldSelector())
      thumb = context.find(".cp_accessory_image_thumb")
      button = context.find(".cp_accessory_image")
      progressBar.fadeOut 300, =>
        thumbnail_url = value_field.data("thumbnailUrl")
        if thumbnail_url and thumbnail_url.length > 0
          thumb.parent().show()  unless "FileReader" of window
          thumb.attr "src", value_field.data("thumbnailUrl")
          button.text "Replace"
        else
          button.text "Add"
        @setImageVariableProgress 0.0, context
        button.css "pointer-events", "auto"
