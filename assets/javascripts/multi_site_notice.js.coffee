MultiSiteNotice = init: ->
  $(".createnew.trial a").click (e) ->
    e.preventDefault()
    new ModalMessage
      title: "Paid Account Required"
      text: "To create an additional website under your account you must have a Format subscription. Please add your payment information to enable this feature."
      modal_class: "medium"
      buttons:
        upgrade:
          text: "Upgrade Now"
          icon: "check"
          classes: "btn_success"
          action: ->
            location.href = "/subscription_upgrade"
        close:
          text: "Close"
          classes: "btn_default"

# init
window.multi_site_notice = MultiSiteNotice
MultiSiteNotice.init()
