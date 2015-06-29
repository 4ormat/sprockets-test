window.Tutorials = {} unless window.Tutorials?

window.Tutorials.show_content = ->
  content_pages_tutorial = new ModalMessage(
    prevent_close: false
    enter_button: "next_slide"
    right_arrow: "next_slide"
    msg_click: "next_slide"
    modal_class: "slideshow content_pages_tutorial"
    html: "<h2>Build Your Perfect Page</h2><p>Start with a completely customizable template<br>or create your own from scratch.</p>"
    buttons:
      slide1:
        classes: "nav_dots nav_dots_selected"
        action: ->
          slide = 1
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Build Your Perfect Page</h2><p>Start with a completely customizable template<br>or create your own from scratch.</p>"
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
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Add Sections</h2><p>Build your page with text, images and more.<br>Drag and drop sections to rearrange your layout.</p>"
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
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Effortless Editing</h2><p>Simply click on any text or image.<br>The toolbar gives you access to additional editing controls.</p>"
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
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Customize Your Images</h2><p>Choose a unique shape to crop your image, or use its original aspect ratio.</p><p>Add an alt text description to improve your site's accessibility.</p>"
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
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Add HTML to Any Layout</h2><p>With a Pro or Agency plan, you can convert any text field to markup.<br>Use custom HTML to embed any type of content.</p>"
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
              content_pages_tutorial.close_modal()
            else
              $(".ModalMessage .nav_dots.slide" + (current + 1)).trigger "click"
          return
    on_create_callback: ->
      # HAX: ModalMessage doesn't seem to be adding the proper icon when first loaded.
      $(".ModalMessage .next_slide").html("<span class='ss-icon'>Next</span> Next").attr "data-cur-slide", 1
  )
  return
