listing = window.Listing = {}

listing.init = ->
  listing.initEvents()
  # Set listing captions
  $('.asset').each ->
    if $(@).hasClass('asset_linked')
      $captionEditor =  $(@).find('.listing_caption_editor')
      if $captionEditor.val().split('\n').length > 1 || listing.getTextareaLineCount($captionEditor) > 1
        $captionEditor.addClass('multi-line')

listing.initEvents = ->
  $(".l_wrapper").on "focus", ".listing_caption_editor", (e) ->
    window.Page.currentItem = $(@).parents('.asset')
    setTimeout =>
      $(@).autosize
        append: ""
    , 50


  $(".l_wrapper").on "input paste", ".listing_caption_editor", (e) ->
    $(@).data('isDirty', true)

  $(".l_wrapper").on "keyup paste", ".listing_caption_editor", (e) ->
    if $(@).val().split('\n').length > 1 || listing.getTextareaLineCount($(@)) > 1
      $(@).addClass('multi-line')
    else
      $(@).removeClass('multi-line')

  $(".l_wrapper").on "blur", ".listing_caption_editor", (e) ->
    $(@).autosize().trigger('autosize.destroy')
    listing.setCaptionForLinkedImage() if $(@).data('isDirty')
    $(@).scrollTop(0)
    setTimeout =>
      if $(@).val().split('\n').length > 1 || listing.getTextareaLineCount($(@)) > 1
        $(@).addClass('multi-line')
      else
        $(@).removeClass('multi-line')
    , 0

listing.getTextareaLineCount = (context) ->
  $ta = context
  lines = 0
  scrollHeight = $ta[0].scrollHeight
  paddingTop = parseInt($ta.css('paddingTop'), 10)
  paddingBottom = parseInt($ta.css('paddingBottom'), 10)
  lineHeight = parseInt($ta.css('lineHeight'), 10)
  lines = Math.floor( ( scrollHeight - (paddingTop + paddingBottom) ) / lineHeight )
  return lines


listing.setCaptionForLinkedImage = ->
  current = window.Page.currentItem
  copy_alignment = null
  $editor = current.find('.listing_caption_editor')
  caption = $editor.val().replace(/\n/g, "<br />")
  editPath = "/assets/#{current.attr('data-asset-id')}"
  if window.Utils.isBlank(caption)
    copy_alignment = 'none'
  else
   copy_alignment = 'only'
  $editor.data('isDirty', false)
  $.ajax(
    type: "PUT",
    data: {
      "asset[copy]": caption,
      "asset[copy_alignment]": copy_alignment
    },
    url: editPath,
    dataType: "html",
    success: (data) ->
      window.APP.notifier.message('is_success', 'Caption Saved')
      window.Page.updateTimestamp()
    )


listing.setLinkForCurrentAsset = (linkHash) ->
  current = window.Page.currentItem
  editPath = "/assets/#{current.attr('data-asset-id')}"
  linkData = {
    "asset[link_type]": linkHash.linkType,
    "asset[link_value]": linkHash.linkValue,
    "asset[open_in_new_window]": linkHash.linkTarget
  }
  $.ajax(
    type: "PUT",
    data: linkData,
    url: editPath,
    success: (data) ->
      current.replaceWith(data)
      $updatedAsset = $('.assets').find('#'+$(data).attr('id')).removeClass('asset_hide')
      $captionEditor = $updatedAsset.find('.listing_caption_editor')
      $img = $updatedAsset.find('img[data-tempsrc]')
      $img.attr('src', $img.attr('data-tempsrc'))
      if $captionEditor.val().split('\n').length > 1 || listing.getTextareaLineCount($captionEditor) > 1
        $captionEditor.css('padding', '5px 13px')
      window.APP.notifier.message('is_success', 'Link Updated')
      window.Page.updateTimestamp()
    )

listing.removeLinkForCurrentAsset = ->
  current = window.Page.currentItem
  editPath = "/assets/#{current.attr('data-asset-id')}"
  linkData = {
    "asset[link_type]": '',
    "asset[link_value]": '',
    "asset[open_in_new_window]": ''
  }
  $.ajax(
    type: "PUT",
    data: linkData,
    url: editPath,
    success: (data) ->
      current.replaceWith(data)
      $updatedAsset = $('.assets').find('#'+$(data).attr('id')).removeClass('asset_hide')
      $captionEditor = $updatedAsset.find('.listing_caption_editor')
      $img = $updatedAsset.find('img[data-tempsrc]')
      $img.attr('src', $img.attr('data-tempsrc'))
      if $captionEditor.val().split('\n').length > 1 || listing.getTextareaLineCount($captionEditor) > 1
        $captionEditor.css('padding', '5px 13px')
      window.APP.notifier.message('is_success', 'Link Removed')
      window.Page.updateTimestamp()
    )