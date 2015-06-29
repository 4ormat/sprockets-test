class @Notices
  @error: (msg) ->
    Notices.create('Error', msg)

  @notice: (msg) ->
    Notices.create('Notice', msg)

  @create: (title, msg) =>
    new ModalMessage
      title: title
      text: msg
      modal_class: "medium"
      buttons:
        close:
          text: "Close"
          classes: "btn_default"
