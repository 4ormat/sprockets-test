class @FormDisabler
  constructor: (options) ->
    @elements = options.elements
    @title = options.title || 'Notice'
    @message = options.message

  disable: =>
    for element in @elements
      $(element).undelegate 'submit'
      $(element).on 'submit', =>
        @formEmailInformation()

  formEmailInformation: =>
    new ModalMessage {
      modal_class : 'small center',
      title : @title,
      text : @message
    }
    false
