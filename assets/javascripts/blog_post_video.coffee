blog_post_video = {}

blog_post_video.video_regex = /(?:http[s]?:\/\/)?(?:www.)?(?:(vimeo).com\/(.*))|(?:(youtu(?:be)?).(?:be|com)\/(?:watch\?v=)?([^&]*)(?:&(?:.))?)/

blog_post_video.template =
  """
    <div class="video_block js_video_block">
      <input type="text" placeholder="Enter a Vimeo or YouTube link here" class="js_video_input">
      <div class="js_video_errors f_is_hidden">Whoops: The Vimeo or YouTube link seems to be invalid</div>
      <div class="js_video_thumbnail thumbnail"></div>
      <a href="javascript:void(0)" class="ss-icon st_video_close js_remove_block">close</a>
      <div class='blog_post_drag_handle_wrapper'>
        <div class='blog_post_drag_handle'></div>
      </div>
    </div>
  """
blog_post_video.className = 'blog_post_video_container'

blog_post_video.editor_wrapper = """
  <div class="blog_post_content_block #{blog_post_video.className}"></div>
"""

blog_post_video.render_template = (contentBlock) ->
  $videoContainer = blog_post_video.render_block()
  blog_post_video.load_video($videoContainer, contentBlock.data).then(->
    contentBlock.data.html = $videoContainer.html()
  )

blog_post_video.render_block = (html) ->
  $(blog_post_video.editor_wrapper).html(html ? blog_post_video.template)

blog_post_video.is_of_type = ($block) ->
  $block.hasClass(blog_post_video.className)

blog_post_video.validate_data = (data) ->
  data.full_url? and data.html? and data.source? and data.remote_id?

blog_post_video.bind_events = ($postContainer) ->
  blog_post_video.bind_url_inputter($postContainer)
  blog_post_video.bind_deleters($postContainer)

blog_post_video.bind_url_inputter = ($postContainer) ->
  $postContainer.on 'keyup change', '.js_video_input', (e) ->
    blog_post_video.handle_input_change($(e.currentTarget))

blog_post_video.bind_deleters = ($postContainer) ->
  $postContainer.on 'click', '.js_video_block .js_remove_block', (e) ->
    $target = $(e.currentTarget)
    modal = new ModalMessage
      title: 'Warning'
      text: 'Are you sure you want to delete this video?'
      modal_class: 'warning small center'
      enter_button: 'Delete'
      buttons:
        'Delete':
          text: 'Delete'
          classes: 'btn_danger'
          icon: 'close'
          action: ->
            $videoContainer = $target.closest(".#{blog_post_video.className}")
            window.APP.blog_post.remove_video($videoContainer)
            window.APP.blog_post.queue_save($('form.js_blog_post'))
            modal.close_modal()
        'Cancel':
          text: 'Cancel'
          classes: 'btn_default'
          action: ->
            window.APP.blog_post.page_is_dirty = false
            modal.close_modal()

blog_post_video.handle_input_change = ($urlInput) ->
  url = $urlInput.val()
  $videoContainer = $urlInput.closest(".#{blog_post_video.className}")
  videos = url.match(blog_post_video.video_regex)
  return blog_post_video.handle_error($videoContainer) unless videos?
  $videoError = $videoContainer.find('.js_video_errors')
  $videoError.addClass('f_is_hidden')
  $urlInput.removeClass('is_error')
  data = {
    html: ''
    full_url: url
  }

  # Work out the source and extract ID
  if(videos[3] != undefined)
    data.source = videos[3]
    data.remote_id = videos[4]
  else if (videos[1] != undefined)
    data.source = videos[1]
    data.remote_id = videos[2]

  if (data.source is "youtu")
    data.source = "youtube"

  # Save the data
  data.html = blog_post_video.get_html(data)
  blog_post_video.load_video($videoContainer, data)

blog_post_video.handle_error = ($videoContainer) ->
  $urlInput = $videoContainer.find('.js_video_input')
  $videoError = $videoContainer.find('.js_video_errors')
  $videoContainer.find('.js_video_thumbnail').html('')
  $videoError.removeClass('f_is_hidden')
  $urlInput.addClass('is_error')

blog_post_video.get_html = (data) ->
  if data.source is "youtube" or data.source is "youtu"
    "<iframe src='#{window.location.protocol}//www.youtube.com/embed/#{data.remote_id}' width='700' height='394' frameborder='0' allowfullscreen></iframe>"
  else if data.source is "vimeo"
    "<iframe src='#{window.location.protocol}//player.vimeo.com/video/#{data.remote_id}?title=0&byline=0' width='700' height='394' frameborder='0'></iframe>"

blog_post_video.load_video = ($videoContainer, data) ->
  $videoContainer.find('.js_video_input').attr('value', data.full_url)
  error_msg = "<p>There was an error loading this video</p>"
  if data.source is "youtube" or data.source is "youtu"
    img = $('<img>', {
      src: "//i.ytimg.com/vi/#{data.remote_id}/mqdefault.jpg"
    })
    $videoContainer.find('.js_video_thumbnail').html(img)
    $videoContainer.find('.js_video_block')
      .attr({
        'data-html': data.html
        'data-full_url': data.full_url
        'data-source': data.source
        'data-remote_id': data.remote_id
      })
      .addClass('video_loaded')
    $.when(data)
  else if data.source is "vimeo"
    $.getJSON("http://vimeo.com/api/oembed.json?url=http%3A//vimeo.com/#{data.remote_id}").then((result) ->
      img = $('<img>', {
        src: result.thumbnail_url
      })
      data.thumbnail_url = result.thumbnail_url
      data.thumbnail_height = result.thumbnail_height
      data.thumbnail_width = result.thumbnail_width
      $videoContainer.find('.js_video_thumbnail').html(img)
      $videoContainer.find('.js_video_block')
        .attr({
          'data-html': data.html
          'data-full_url': data.full_url
          'data-source': data.source
          'data-remote_id': data.remote_id
        })
        .addClass('video_loaded')
      data
    , ->
      $videoContainer.find('.js_video_thumbnail').html(error_msg)
    )

window.blog_post_video = blog_post_video
