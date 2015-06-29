window.Tutorials = {} unless window.Tutorials?

window.Tutorials.show_gallery = ->
  gallery_tutorial = new ModalMessage(
    prevent_close: false
    enter_button: "next_slide"
    right_arrow: "next_slide"
    msg_click: "next_slide"
    modal_class: "slideshow gallery_tutorial"
    html: "<h2>This is a Gallery Page</h2><p>Gallery pages are used to showcase your work. Add images, videos and text.</p>"
    buttons:
      slide1:
        classes: "nav_dots nav_dots_selected"
        action: ->
          slide = 1
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>This is a Gallery Page</h2><p>Gallery pages are used to showcase your work. Add images, videos and text.</p>"
              $(".ModalMessage .msg").removeClass "is_hidden"
              return
            ), 300
            $(".ModalMessage .nav_dots_selected").removeClass "nav_dots_selected"
            $(".ModalMessage .nav_dots.slide" + slide).addClass "nav_dots_selected"


          return

      slide2:
        classes: "nav_dots"
        action: ->
          slide = 2
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Add Content</h2><p>Click 'Add Item' to add an image, a video, or text.</p>"
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
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Drag &amp; Drop</h2><p>Rearrange the items in your gallery easily by clicking and dragging into place.</p>"
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
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Edit Easily</h2><p>Click an item to edit it.<br/>Replace a photo, update a<br/>video or rewrite a caption.</p>"
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
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Page Titles</h2><p>Add a page title to introduce your work.<br/>Title elements will display differently on every theme.</p>"
              $(".ModalMessage .msg").removeClass "is_hidden"
              return
            ), 300
            $(".ModalMessage .nav_dots_selected").removeClass "nav_dots_selected"
            $(".ModalMessage .nav_dots.slide" + slide).addClass "nav_dots_selected"
            $(".ModalMessage .next_slide").html("<span class='ss-icon'>Next</span> Next").attr "data-cur-slide", slide
          return

      slide6:
        classes: "nav_dots"
        action: ->
          slide = 6
          if not $(".ModalMessage .msg").hasClass("slide_" + slide) or not $(".ModalMessage .msg").hasClass("is_hidden")
            $(".ModalMessage .msg").addClass "is_hidden"
            setTimeout (->
              $(".ModalMessage .msg").removeClass("slide_1 slide_2 slide_3 slide_4 slide_5 slide_6").addClass("slide_" + slide).html "<h2>Add Alt Text</h2><p>Add alt text on the gallery view or in the Alt Text Editor <br>to make your work more discoverable.</p>"
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
