window.Tutorials = {} unless window.Tutorials?

window.Tutorials.show_dashboard = ->
  gallery_tutorial = new ModalMessage(
    prevent_close: false
    enter_button: "next_slide"
    right_arrow: "next_slide"
    msg_click: "next_slide"
    modal_class: "slideshow dashboard_tour"
    html: "<h2>Getting Started</h2><p>Using Format is simple. Here’s what you need to know to create your website.</p>"
    buttons:
      slide1:
        classes: "nav_dots nav_dots_selected"
        action: ->
          slide = 1
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Getting Started</h2><p>Using Format is simple. Here’s what you need to know to create your website.</p>"
              $(".ModalMessage .msg").removeClass "is_hidden"
              return
            ), 300
            $(".ModalMessage .nav_dots_selected").removeClass "nav_dots_selected"
            $(".ModalMessage .nav_dots.slide" + slide).addClass "nav_dots_selected"
            $(".ModalMessage .next_slide").html("<span class='ss-icon'>Next</span> Next").attr "data-cur-slide", slide

          return

      slide2:
        classes: "nav_dots"
        action: ->
          slide = 2
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5").addClass("slide_" + slide).html "<h2><span class='ss-icon'>page</span>&nbsp;Pages</h2><p>Manage pages in your menu, and create galleries for your images, videos, and text.</p>"
              $(".ModalMessage .msg").removeClass "is_hidden"
              return
            ), 300
            $(".ModalMessage .nav_dots_selected").removeClass "nav_dots_selected"
            $(".ModalMessage .nav_dots.slide" + slide).addClass "nav_dots_selected"
            $(".ModalMessage .next_slide").html("<span class='ss-icon'>Next</span> Next").attr "data-cur-slide", slide
          return

      slide3:
        classes: "nav_dots"
        action: ->
          slide = 3
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5").addClass("slide_" + slide).html "<h2><span class='ss-icon'>book</span>&nbsp;Blogs</h2><p>Powerful image-based blogging, integrated into your portfolio website. Share all your work quickly and easily.
  </p>"
              $(".ModalMessage .msg").removeClass "is_hidden"
              return
            ), 300
            $(".ModalMessage .nav_dots_selected").removeClass "nav_dots_selected"
            $(".ModalMessage .nav_dots.slide" + slide).addClass "nav_dots_selected"
            $(".ModalMessage .next_slide").html("<span class='ss-icon'>Next</span> Next").attr "data-cur-slide", slide
          return

      slide4:
        classes: "nav_dots"
        action: ->
          slide = 4
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5").addClass("slide_" + slide).html "<h2><span class='ss-icon'>layout</span>&nbsp;Design</h2><p>Browse and try out different themes. You can edit your site <br>colors and styles with the Theme Editor.</p>"
              $(".ModalMessage .msg").removeClass "is_hidden"
              return
            ), 300
            $(".ModalMessage .nav_dots_selected").removeClass "nav_dots_selected"
            $(".ModalMessage .nav_dots.slide" + slide).addClass "nav_dots_selected"
            $(".ModalMessage .next_slide").html("<span class='ss-icon'>Next</span> Next").attr "data-cur-slide", slide
          return

      slide5:
        classes: "nav_dots"
        action: ->
          slide = 5
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5").addClass("slide_" + slide).html "<h2><span class='ss-icon'>gear</span>&nbsp;Settings</h2><p>Set up your domain, website favicon and manage your billing.</p>"
              $(".ModalMessage .msg").removeClass "is_hidden"
              return
            ), 300
            $(".ModalMessage .nav_dots_selected").removeClass "nav_dots_selected"
            $(".ModalMessage .nav_dots.slide" + slide).addClass "nav_dots_selected"
            $(".ModalMessage .next_slide").html("<span class='ss-icon'>check</span> Done").attr "data-cur-slide", 0
          return

      next_slide:
        text: "Next"
        classes: "btn_success"
        icon: "Next"
        action: ->
          $(".ModalMessage .nav_dots_selected").removeClass "nav_dots_selected"
          unless $(this).attr("data-cur-slide")
            $(".ModalMessage .nav_dots.slide2").trigger "click"
          else
            current = parseInt($(this).attr("data-cur-slide"), 10)
            if current is 0
              gallery_tutorial.close_modal()
            else
              $(".ModalMessage .nav_dots.slide" + (current + 1)).trigger "click"
          return
    on_create_callback: ->
      # HAX: ModalMessage doesn't seem to be adding the proper icon when first loaded.
      $(".ModalMessage .next_slide").html("<span class='ss-icon'>Next</span> Next").attr "data-cur-slide", 1
  )
  return
