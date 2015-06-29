#Extends Sir Trevor to add image galleries automatically
SirTrevor.Blocks.Gallery = (() ->

  return SirTrevor.Block.extend

    type: "Gallery"
    icon_name: 'gallery'
    editorHTML: "an image gallery"
    update_queue: null

    render: ->
      gallery_id = null
      gallery_type = "smart grid"
      gallery = @blockStorage.data.image_gallery

      #if this is re-rendering a saved gallery, get the template with id and style from markdown [image-intelligent: 12]

      if gallery
        gallery_id = gallery.replace(/[^0-9]+/g, '');
      $.when(
        @getTemplateBlock(gallery_id)
      ).done((res) =>
        res = $.parseJSON(res)
        @editorHTML = res.html;

        @beforeBlockRender();
        @_setBlockInner();

        @$editor = @$inner.children().first()

        if(@droppable || @pastable || @uploadable)
          input_html = $("<div>", { 'class': 'st-block__inputs' });
          @$inner.append(input_html);
          @$inputs = input_html;

        if (@hasTextBlock)
          @_initTextBlocks()
        if (@droppable)
          @withMixin(SirTrevor.BlockMixins.Droppable)
        if (@pastable)
          @withMixin(SirTrevor.BlockMixins.Pastable)
        if (@uploadable)
          @withMixin(SirTrevor.BlockMixins.Uploadable)
        if (@fetchable)
          @withMixin(SirTrevor.BlockMixins.Fetchable)

        if (@formattable)
          @_initFormatting()

        @_blockPrepare();
        @onBlockRender();

      )
      return @

    onBlockRender: ->

      $('.js_images_wrapper',@$el).sortable({
          handle: '.blog_post_images_wrapper_item_image'
          placeholder: 'ui-sortable-placeholder'
          helper: 'clone'
          update: (event, ui) =>
            this.queue_update()
          change: (event, ui) ->
            container_width = $('.js_images_wrapper').width()
            el_width = $('.js_images_wrapper_item').first().width()
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

      $('.js_images_wrapper .js_caption_editor', @$el).on 'keyup focus blur change', =>
        this.queue_update()

      parent = @$el

      $('.js_images_wrapper', @$el).on 'click', '.js_blog_image_delete', (e) =>
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
                self = e.target
                id = $(self).prev('img').data('asset')
                group_id = $('.js_blog_post_image_gallery', @$el).data('group')
                data = {"_method":"delete"}
                response = $.post '/site/blog/posts/'+post_id+'/image_group/'+group_id+'/post_asset/'+id,
                  data
                  () =>
                    $(self).parent().parent().remove()
                    @checkImageCount()
                    window.APP.blog_post.queue_save($('form.js_blog_post'))
                modal.close_modal()
            'Cancel':
              text: 'Cancel'
              classes: 'btn_default'
              action: ->
                modal.close_modal()

      $('.js_change_imageset_type', @$el).click ->
        $(@).addClass('is_open')
        $(@).bind('mouseleave', =>
          $(@).removeClass('is_open')
          $(@).unbind('mouseleave')
        )

      $('.js_change_imageset_type li', @$el).click (e) =>
        e.stopPropagation()
        new_type = $.trim($(e.target).text())
        $('.js_change_imageset_type').removeClass('is_open')
        $(e.target).parents('div[data-type="Gallery"]').find('.js_change_imageset_type_label').html($(e.target).html())
        $(e.target).parents('.js_blog_post_image_gallery').data('image_style', new_type)
        $('form.js_blog_post').trigger('change')
        $(e.target).parent().unbind('mouseleave')
        @queue_update()

      $('.js_caption_editor', @$el).each(->
        val = $(@).text().replace(/\s/g, '');
        if(val != '')
          $(@).parent().removeClass('is_empty')
      )

      $('.js_images_wrapper', @$el).on 'click', '.js_caption_trigger', (e) ->
        # remove the non-editing and empty states
        $(@).parent().removeClass('is_empty').addClass('is_editing')
        $(@).parent().find('.js_caption_editor').focus()

      $('.js_images_wrapper', @$el).on 'blur', '.js_caption_editor', (e) =>
        content  = $(e.target).text()
        if(content == '')
          $(e.target).parent().find('.js_caption_trigger').text('Add Caption...')
          $(e.target).parent().addClass('is_empty')
        else
          $(e.target).parent().find('.js_caption_trigger').text(content)
          $(e.target).parent().removeClass('is_empty')
          @queue_update()
        $(e.target).parent().removeClass('is_editing')

      $('.js_images_wrapper', @$el).on 'keypress', '.js_caption_editor', (e) ->
        if (e.keyCode == 13 || $(this).text().replace(/\s/g, '').length > 300)
          return false

      # remove image set event
      $('.js_remove_block', @$el).click (e) ->
        e.stopPropagation()
        window.APP.blog_post.page_is_dirty = true
        modal = new ModalMessage
          title: 'Warning'
          text: 'Are you sure you want to delete this image set?'
          modal_class: 'warning small center'
          enter_button: 'Delete'
          buttons:
            'Cancel':
              text: 'Cancel'
              classes: 'btn_default'
              action: ->
                window.APP.blog_post.page_is_dirty = false
                modal.close_modal()
            'Delete':
              text: 'Delete'
              classes: 'btn_danger'
              icon: 'trash'
              action: =>
                id = $(this).parent().data('group')
                data = {"_method":"delete"}
                response = $.post '/site/blog/posts/'+post_id+'/image_group/'+id,
                  data
                  () =>
                    window.APP.blog_post.queue_save($('form.js_blog_post'))
                    window.APP.blog_post.st.removeBlock($(this).parents('.st-block').attr('id'))
                    window.APP.blog_post.combine_content_blocks()
                modal.close_modal()

      # add image event
      $('.js_blog_post_add_image', @$el).click (e) =>
        e.preventDefault()
        VfsUi.open_multi("assets",
          (args) =>
            @uploadImages(args)
            return
        )
        return

      $('.st-block-ui-btn--reorder', @$el).click (e) =>
        if($('.st-block-ui-btn--reorder', @$el).hasClass('js_st_add_image'))
          $('.js_blog_post_add_image', @$el).trigger('click')
          return

      @checkImageCount()

      if(@$el.next().attr('data-type') != 'text')
        window.APP.blog_post.st.createBlock("text", '', @$el)

      return

    toData: ->

      dataObj = {};

      block = $('.js_blog_post_image_gallery', @$el)

      #if there is only one image, fake a vertical gallery
      gallery_style = block.data('image_style')
      if $('.js_images_wrapper img', @$el[0]).length == 1
        gallery_style = "vertical"

      if block.length>0
        dataObj["image_gallery"] = "[image-"+gallery_style+": "+block.data('group')+"]"

      if !_.isEmpty(dataObj)
        @setData(dataObj)

      return

    queue_update: () ->
      clearTimeout(@update_queue)
      @update_queue = setTimeout(=>
        @update_images()
      ,1000)

    update_images:  ( event, ui ) ->
      # build data hash
      self = this
      group_id = $('.js_blog_post_image_gallery', @$el).data('group')
      image_style = $('.js_blog_post_image_gallery', @$el).data('image_style')
      data = {}
      post_assets = []
      $imgs = $('.js_blog_post_image_gallery .js_asset', @$el)
      for img, i in $imgs
        post_assets.push({
          'id': $(img).data('asset'),
          'position': i+1
        })
        caption = $(img).parent().parent().find('.js_caption_editor').text().trim()
        if caption != ''
         post_assets[post_assets.length - 1].caption = caption
      data.id = group_id
      data.post_image_group = {}
      data.post_image_group.display_style = image_style
      data.post_image_group.post_assets_attributes = {}
      data.post_image_group.post_assets_attributes = post_assets

      response = $.post '/site/blog/posts/'+post_id+'/image_group/'+group_id+'/update_images',
        data
        () =>
          @checkImageCount()
          window.APP.blog_post.queue_save($('form.js_blog_post'))
      return response

    uploadImages: (data) ->
      group_id = $('.js_blog_post_image_gallery', @$el).data('group')
      $.post '/site/blog/posts/'+post_id+'/image_group/'+group_id+'/add_images',
        image_group: group_id
        vfs_files: data
        (data) =>
          window.APP.blog_post.queue_save($('form.js_blog_post'))
          @showImages(data)
          @checkImageCount()
          return
      return

    showImages: (images) ->
      $image_container = $('.js_images_wrapper', @$el)
      for image, i in images
        $image_container.append('<div class="blog_post_images_wrapper_item js_images_wrapper_item"><div class="blog_post_images_wrapper_item_image"><img src="' + image['vfs_file']['thumbnails']['0x150']['src'] + '" class="js_asset" data-asset="'+ image['id']+'"><a href="javascript:void(0)" class="ss-icon f_close_icon js_blog_image_delete">close</a></div><div class="blog_post_item_caption _image_caption is_empty"><div class="blog_post_item_caption_trigger js_caption_trigger">Add Caption...</div><div class="blog_post_item_caption_editor js_caption_editor" contentEditable="true"></div></div></div>')
      @checkImageCount()
      return

    checkImageCount: ->
      if $('.js_images_wrapper img', @$el).length > 0
        $('.st-block-ui-btn--reorder', @$el).removeClass('js_st_add_image');
        $('.js_blog_post_image_gallery',@$el).removeClass('blog_post_image_gallery_empty')
        #hide gallery type if only 1 image
        if $('.js_images_wrapper img', @$el[0]).length <= 1
          $('.js_imageset_type_label, .js_change_imageset_type',@$el).addClass('f_is_hidden')
        else
          $('.js_imageset_type_label, .js_change_imageset_type',@$el).removeClass('f_is_hidden')
      else
        $('.st-block-ui-btn--reorder', @$el).addClass('js_st_add_image');
        $('.js_blog_post_image_gallery',@$el).addClass('blog_post_image_gallery_empty')
      return

    getTemplateBlock: (gallery_id) ->
      response = ''
      if gallery_id #render an old post
        response = $.get '/site/blog/posts/'+post_id+'/image_group/'+gallery_id,
          =>
            @checkImageCount()
      else
        response = $.post '/site/blog/posts/'+post_id+'/image_group/',
          =>
            @checkImageCount()
      return response

)()
