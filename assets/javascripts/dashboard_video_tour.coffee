DashboardVideo = window.DashboardVideo = {}
DashboardVideo.show_dashboard_video = ->
  TOUR_VIDEO = '<iframe src="//player.vimeo.com/video/98677917?autoplay=1" width="654" height="367" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
  dashboard_video = new ModalMessage(
    prevent_close: true
    enter_button: "next_slide"
    modal_class: "slideshow dashboard_video"
    html: "<div class='tour_media_holder'><div class='tour_play_button'><span class='ss-icon'>play</span></div></div><h2>New Changes at Format</h2><p>Watch the 30 second video.</p><a href='javascript:void(0)' class='skip_dashboard_video'>Skip</a><a href='javascript:void(0)' class='close_dashboard_video'>&times;</a>"
  )
  $('body').on 'keyup', (e) ->
    if e.keyCode is 27
      dashboard_video.close_modal()
  $('body').on 'click', '.skip_dashboard_video, .close_dashboard_video', ->
    dashboard_video.close_modal()
  $('body').on 'click', '.tour_media_holder', ->
    $('.skip_dashboard_video').hide()
    $('.close_dashboard_video').show()
    $(@).html(TOUR_VIDEO)
    $('body').on 'click', ->
      dashboard_video.close_modal()
  return
