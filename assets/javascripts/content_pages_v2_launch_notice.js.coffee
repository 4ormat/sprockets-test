window.contentPagesLaunchNotice = {}

window.contentPagesLaunchNotice.show = ->
  launch_notice = new ModalMessage(
    prevent_close: false
    enter_button: "createPage"
    modal_class: "slideshow content-pages-launch-notice"
    html: """
      <h2>Custom Pages are Now Available</h2>
      <p>Quickly build the perfect layout using flexible, customizable tools.</p>
    """
    buttons:
      createPage:
        text: 'Create a Custom Page'
        classes: "btn_success btn_large content-pages-launch-notice-cta"
        action: ->
          window.location = '/site/content_page_templates/text'
          return
  )
  return
