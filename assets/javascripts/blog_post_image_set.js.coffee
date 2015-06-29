blog_post_image_set = {}

blog_post_image_set.create_block = ->
  {
    type: 'gallery'
    data: {}
  }

blog_post_image_set.className = 'blog_post_image_set_container'

blog_post_image_set.editor_wrapper = """
  <div class="blog_post_content_block #{blog_post_image_set.className}"></div>
"""

blog_post_image_set.render_block = (blockHTML) ->
  $(blog_post_image_set.editor_wrapper).html(blockHTML)

blog_post_image_set.is_of_type = ($block) ->
  $block.hasClass(blog_post_image_set.className)

blog_post_image_set.decorate = ($galleryContainer) ->
  if $galleryContainer.find('.js_images_wrapper img').length > 0
    $galleryContainer.find('.js_blog_post_image_gallery').removeClass('blog_post_image_gallery_empty')
    #hide gallery type if only 1 image
    if $galleryContainer.find('.js_images_wrapper img').length is 1
      $galleryContainer.find('.js_imageset_type_label, .js_change_imageset_type').addClass('f_is_hidden')
    else
      $galleryContainer.find('.js_imageset_type_label, .js_change_imageset_type').removeClass('f_is_hidden')
    $galleryContainer.find('.js_caption_editor').each(->
      $caption = $(@)
      val = $caption.text().replace(/\s/g, '')
      if(val isnt '')
        $caption.closest('.js_image_caption').removeClass('is_empty')
    )
  else
    $galleryContainer.addClass('js_st_add_image')
    $galleryContainer.find('.js_blog_post_image_gallery').addClass('blog_post_image_gallery_empty')

blog_post_image_set.getTemplateBlock = (post_id, gallery) ->
  galleryFetch =
    if gallery.data.image_gallery_id? # render a pre-existing image set
      $.get("/site/blog/posts/#{post_id}/image_group/#{gallery.data.image_gallery_id}")
    else # create a new image set
      $.post("/site/blog/posts/#{post_id}/image_group/")
  galleryFetch.then(
    (data) ->
      source = JSON.parse(data ? null)?.html
      if source?
        $galleryContainer = $(blog_post_image_set.editor_wrapper).html(source)
        blog_post_image_set.decorate($galleryContainer)
        gallery.data.html = $galleryContainer.html()
      data
    , () ->
      gallery.data.html = ""
      $.when(true)
  )

blog_post_image_set.bind_events = ($postContainer) ->
  blog_post_image_set.bind_set_deleters($postContainer)
  blog_post_image_set.bind_type_setters($postContainer)
  blog_post_image_set.bind_image_deleters($postContainer)
  blog_post_image_set.bind_image_adders($postContainer)
  blog_post_image_set.bind_image_caption_editors($postContainer)

blog_post_image_set.bind_set_deleters = ($galleryContainers) ->
  $galleryContainers.on 'click', '.js_blog_post_image_gallery .js_remove_block', (e) ->
    e.stopPropagation()
    e.preventDefault()
    $target = $(e.currentTarget)
    modal = new ModalMessage
      title: 'Warning'
      text: 'Are you sure you want to delete this image set?'
      modal_class: 'warning small center'
      enter_button: 'Delete'
      buttons:
        'Delete':
          text: 'Delete'
          classes: 'btn_danger'
          icon: 'close'
          action: ->
            id = $target.closest('.js_blog_post_image_gallery').data('group')
            data = {"_method":"delete"}
            response = $.post "/site/blog/posts/#{window.APP.blog_post.post_id}/image_group/#{id}",
              data,
              () ->
                window.APP.blog_post.remove_image_set(id)
                window.APP.blog_post.queue_save($('form.js_blog_post'))
            modal.close_modal()
        'Cancel':
          text: 'Cancel'
          classes: 'btn_default'
          action: ->
            window.APP.blog_post.page_is_dirty = false
            modal.close_modal()

blog_post_image_set.make_photos_sortable = ($el) ->
  $galleryContainers = $el.find('.js_images_wrapper')
  $galleryContainers.sortable({
    handle: '.blog_post_images_wrapper_item_image'
    placeholder: 'ui-sortable-placeholder'
    helper: 'clone'
    update: (event, ui) ->
      blog_post_image_set.update_images($(@).closest('.js_blog_post_image_gallery'))
    change: (event, ui) ->
      container_width = $galleryContainers.width()
      el_width = $galleryContainers.find('.js_images_wrapper_item').first().width()
      on_left_side = (pos) -> return pos < el_width
      on_right_side = (pos) -> return pos > container_width - el_width

      # if I am trying to move an element to the first position in the row,
      # the placeholder needs to be the first item in the row, and not the last
      # item in the previous row.
      if on_right_side(ui.placeholder.position().left) and on_left_side(ui.position.left)
        ui.placeholder.css('clear', 'left')
      else
        ui.placeholder.css('clear', 'none')
  })

blog_post_image_set.bind_type_setters = ($galleryContainers) ->
  $galleryContainers.on('click', '.js_change_imageset_type', (e) ->
    $target = $(e.currentTarget)
    $target.addClass('is_open')
    $target.on('mouseleave', ->
      blog_post_image_set.closeTypeDropdown = window.setTimeout(->
        $target.removeClass('is_open')
        $target.unbind('mouseleave')
      , 500)
    )
    $target.on('mouseenter', ->
      window.clearTimeout(blog_post_image_set.closeTypeDropdown)
    )
  )

  $galleryContainers.on('click', '.js_change_imageset_type li', (e) ->
    e.stopPropagation()
    $target = $(e.currentTarget)
    $galleryContainer = $target.closest('.blog_post_image_set_container')
    new_type = $.trim($target.text())
    $('.js_change_imageset_type').removeClass('is_open')
    $galleryContainer.find('.js_change_imageset_type_label').html($target.html())
    $galleryContainer.find('.js_blog_post_image_gallery').data('image_style', new_type)
    $('form.js_blog_post').trigger('change')
    $target.parent().off('mouseleave mouseenter')
    blog_post_image_set.update_images($galleryContainer.find('.js_blog_post_image_gallery'))
  )

blog_post_image_set.bind_image_deleters = ($galleryContainers) ->
  $galleryContainers.on 'click', '.js_blog_image_delete', (e) ->
    e.preventDefault()
    modal = new ModalMessage
      title: 'Warning'
      text: 'Are you sure you want to delete this image?'
      modal_class: 'warning small center'
      enter_button: 'Delete'
      buttons:
        'Delete':
          text: 'Delete'
          classes: 'btn_danger'
          icon: 'close'
          action: =>
            $target = $(e.currentTarget)
            id = $target.siblings('.js_asset').data('asset')
            group_id = $target.closest('.js_blog_post_image_gallery').data('group')
            data = {"_method":"delete"}
            response = $.post "/site/blog/posts/#{window.APP.blog_post.post_id}/image_group/#{group_id}/post_asset/#{id}",
              data,
              () =>
                $target.closest('.js_images_wrapper_item').remove()
                blog_post_image_set.decorate($target.closest('.blog_post_image_set_container'))
                window.APP.blog_post.queue_save($('form.js_blog_post'))
            modal.close_modal()
        'Cancel':
          text: 'Cancel'
          classes: 'btn_default'
          action: ->
            modal.close_modal()

blog_post_image_set.bind_image_adders = ($galleryContainers) ->
  $galleryContainers.on 'click', '.js_blog_post_add_image', (e) ->
    e.preventDefault()
    VfsUi.open_multi("assets",
      (args) =>
        $galleryContainer = $(e.currentTarget).closest('.blog_post_image_set_container')
        blog_post_image_set.upload_images(args, $galleryContainer)
    )

blog_post_image_set.bind_image_caption_editors = ($postContainer) ->

  $postContainer.on 'click', '.js_caption_trigger', (e) ->
    $target = $(e.currentTarget)
    # remove the non-editing and empty states
    $target.closest('.js_image_caption')
      .removeClass('is_empty')
      .addClass('is_editing')
      .find('.js_caption_editor').focus()

  $postContainer.on 'blur', '.js_caption_editor', (e) ->
    $target = $(e.currentTarget)
    content  = $target.text()
    if content is ''
      $target.closest('.js_image_caption')
        .addClass('is_empty')
        .removeClass('is_editing')
        .find('.js_caption_trigger')
          .text('Add Caption...')
    else
      $target.closest('.js_image_caption')
        .removeClass('is_empty is_editing')
        .find('.js_caption_trigger')
          .text(content)
      blog_post_image_set.update_images($target.closest('.js_blog_post_image_gallery'))

  $postContainer.on 'keypress', '.js_caption_editor', (e) ->
    if (e.keyCode == 13 || $(e.currentTarget).text().replace(/\s/g, '').length > 300)
      return false

blog_post_image_set.upload_images = (uploadData, $galleryContainer) ->
  group_id = $galleryContainer.find('.js_blog_post_image_gallery').data('group')
  data = {
    image_group: group_id
    vfs_files: uploadData
  }
  $.post "/site/blog/posts/#{window.APP.blog_post.post_id}/image_group/#{group_id}/add_images",
    data,
    (data) =>
      window.APP.blog_post.queue_save($('form.js_blog_post'))
      blog_post_image_set.show_images(data, $galleryContainer)
      blog_post_image_set.decorate($galleryContainer)

blog_post_image_set.show_images = (images, $galleryContainer) ->
  $image_container = $galleryContainer.find('.js_images_wrapper')
  for image, i in images
    $image_container.append """
      <div class="blog_post_images_wrapper_item js_images_wrapper_item">
        <div class="blog_post_images_wrapper_item_image">
          <img src="#{image['vfs_file']['thumbnails']['0x150']['src']}" class="js_asset" data-asset="#{image['id']}">
          <a href="#" class="ss-icon f_close_icon js_blog_image_delete">close</a>
        </div>
        <div class="blog_post_item_caption js_image_caption is_empty">
          <div class="blog_post_item_caption_trigger js_caption_trigger">Add Caption...</div>
          <div class="blog_post_item_caption_editor js_caption_editor" contentEditable="true"></div>
        </div>
      </div>
    """
  true

blog_post_image_set.update_images = _.debounce(($gallery) ->
  # build data hash
  group_id = $gallery.data('group')
  image_style = $gallery.data('image_style')
  data = {}
  post_assets = []
  $imgs = $gallery.find('.js_asset')
  for img, i in $imgs
    $img = $(img)
    post_assets.push({
      'id': $img.data('asset'),
      'position': i+1
    })
    caption = $img.closest('.js_images_wrapper_item').find('.js_caption_editor').text().trim()
    if caption isnt ''
     post_assets[post_assets.length - 1].caption = caption
  data.id = group_id
  data.post_image_group = {}
  data.post_image_group.display_style = image_style
  data.post_image_group.post_assets_attributes = {}
  data.post_image_group.post_assets_attributes = post_assets

  $.post(
    "/site/blog/posts/#{window.APP.blog_post.post_id}/image_group/#{group_id}/update_images",
    data,
    () =>
      blog_post_image_set.decorate($gallery.closest('.blog_post_image_set_container'))
      window.APP.blog_post.queue_save($('form.js_blog_post'))
  )
, 1000)

window.blog_post_image_set = blog_post_image_set
