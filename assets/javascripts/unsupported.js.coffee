# Migation from an unsupported theme page (unsupported.html.haml)

U = window.Unsupported_theme = {}

$ ->
  U.init_events()

U.init_events = ->
  $('.js_migrate_confirm_cancel').on 'click', U.show_cancel_confirmation
  $('.js-unsupported-theme-learn-more').on 'click', U.show_learn_more
  $('.js_fs_message_overlay_close').on 'click', U.close_overlay
  `_kmq.push(['trackClick', '.upgrade', 'Clicked Upgrade Suggestion Link', {
    'user_id':user_id
  }]);`

U.show_cancel_confirmation = (e) ->
  e.preventDefault()
  content = $('.js_migrate_confirm_cancel_content')

  modal = new ModalMessage
    title: content.children('h2').html()
    text: content.children('p').html()
    modal_class: 'medium warning center'
    prevent_close: false
    enter_button: 'later'
    buttons: 
      close: 
        text: 'Back'
        classes: 'btn_default'
        action: ->
          modal.close_modal()
      later: 
        text: 'Upgrade Later'
        classes: 'btn_danger'
        action: ->
          modal.close_modal()
          # continue on to the original href from the <a>
          history.back(1)


U.show_learn_more = ->
  content = $('.js_migrate_learn_more_content')

  modal = new ModalMessage
    title: content.children('h2').html()
    html: content.children('p').html()
    modal_class: 'medium'
    enter_button: 'button'
    buttons: 
      close: 
        text: 'Close'
        classes: 'btn_default'

U.close_overlay = ->
  if history.length > 1
    window.history.back()
  else
    window.location = "/site/dashboard"