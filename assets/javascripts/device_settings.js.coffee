class @DeviceSettings

  bindControls: =>
    @deviceThemeToggle().change => @setThemeUsage()
    @submit().click => @save()
    @imageUploaderValue().each (i, uploader) => @initImageUpload($(uploader))
    @colorChoiceToggle().change => @changePreviewBackgroundColour()
    @deviceThemeToggle().change (event) => @markPanelAsDirty()
    @colorChoiceToggle().change (event) => @markPanelAsDirty()


  initControls: =>
    @setThemeUsage()

  changePreviewBackgroundColour: =>
    deviceColor = @colorChoiceToggle().find('option:selected').data('background-color')
    @preview.setDeviceColor(deviceColor)
    true

  hideControls: =>
    @websiteMessage().show()
    @themeMessage().hide()
    @colorChoicePanel().hide()

    @logoImage().hide()
    @preview.showDeviceTheme()

  initImageUpload: (uploader) =>
    token = @crsfToken().attr("content")
    progressBar = uploader.find(".progress").progressbar()

    uploader.fileUploadUI
      requestHeaders:
        "X-CSRF-Token": token

      progressAllNode: progressBar
      previewSelector: null
      initUpload: (event, files, index, xhr, handler, callBack) ->
        regexp = /\.(png)|(jpg)|(gif)|(jpeg)$/i
        unless regexp.test(files[index].name)
          modal = new ModalMessage(
            title: "Warning"
            text: "File must be a JPEG, PNG, or GIF."
            modal_class: "warning small"
          )
          return
        if files[index].size > 8388608
          modal = new ModalMessage(
            title: "Warning"
            text: "File must be less than 8MB in size."
            modal_class: "warning small"
          )
          return
        callBack()

      onSend: (event, files, index, xhr, handler) =>
        uploader.find(".error_message, .remove, .file_name").hide()
        uploader.find(".progress").show()

      onLoad: (event, files, index, xhr, handler) =>
        result = $.parseJSON(xhr.responseText)
        if result["error"]
          uploader.find(".error_message").text(result["error"]).fadeIn()
          uploader.find(".progress").fadeOut()
          uploader.find(".file_name, .remove").fadeIn()  unless uploader.find(".file_name").text() is ""
        else
          uploader.find(".progress").fadeOut()
          uploader.find(".file_name").text files[0].name
          uploader.find(".file_name, .remove").fadeIn()
          @showTitleImage result["src"]

      onError: (event, files, index, xhr, handler) =>
        uploader.find(".error_message").text "An Error Occurred. Please Try Again."
        uploader.find(".progress").fadeOut()
        uploader.find(".file_name, .remove").fadeIn()  unless uploader.find(".file_name").text() is ""

    uploader.find(".remove").click => @removeImage

  removeImage: =>
    url = "/site/menu_title_images/"
    data = _method: "put"
    data["menu_title_image_mobile_attributes[_destroy]"] = true
    $.ajax(
      url: url
      data: data
      dataType: "json"
      type: "DELETE"
    ).success (data) =>
      @fileName().text ""
      @fileName().fadeOut()
      @removeMessage().fadeOut()
      @errorMessage().fadeOut()

    false


  markPanelAsDirty: (context) =>
    @panel().data('dirty', true)

  setThemeUsage: =>
    if @useTouchInterface()
      @showControls()
    else
      @hideControls()
    false

  showControls: =>
    @websiteMessage().hide()
    @themeMessage().show()
    @colorChoicePanel().show()
    @disclaimer().show()
    @logoImage().show()
    @preview.showDeviceTouch()

  showTitleImage: (src) ->
    if src
      @logoImage().attr("src", src).show()

  useTouchInterface: =>
    @deviceThemeToggle().is(":checked")

  ## Selectors
  #

  colorChoicePanel: =>
    @panel().find(".touch_theme_color")

  colorChoiceToggle: =>
    @panel().find("#toggle_theme_color")

  crsfToken: ->
    $("meta[name=\"csrf-token\"]")

  deviceThemeToggle: =>
    @panel().find(".cp_accessory_switch.toggle_touch_theme")

  disclaimer: =>
    @panel().find(".disclaimer")

  errorMessage: =>
    @panel().find('.error_message')

  fileName: =>
    @panel().find(".file_name")

  imageUploader: =>
    @panel().find(".img_uploader")

  imageUploaderValue: =>
    @imageUploader().find(".value")

  logoFile: =>
    @panel().find(".hidden_file")

  logoImage: =>
    @panel().find(".touch_theme_logo")

  panel: =>
    $('#cp_panel_' + @platform)

  saveButton: =>
    $('#btn_apply_changes')

  removeMessage: =>
    @panel().find('.remove')

  themeMessage: =>
    @panel().find(".description #theme")

  websiteMessage: =>
    @panel().find(".description #website")
