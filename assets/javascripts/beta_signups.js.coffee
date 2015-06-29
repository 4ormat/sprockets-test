class @BetaSignups
  init: =>
    $('.toggle a').on 'click', =>
      @toggleSelect()

    $('a.approve').on 'click', =>
      @approve()

    $('a.unapprove').on 'click', =>
      @unapprove()

  approve: =>
    @update 'true', @collectSelectedIds()

  unapprove: =>
    @update 'false', @collectSelectedIds()

  collectSelectedIds: ->
    $.map $('.selector input:checked'), (i) ->
      $(i).val()

  update: (approval, ids) ->
    url = "#{window.location.href}&authenticity_token=#{AUTH_TOKEN}"

    form = $('<form action="' + url + '" method="post">' +
    '<input type="text" name="_method" value="PUT" />' +
    '<input type="text" name="approval" value="' + approval + '" />' +
    '<input type="text" name="beta_signup_ids" value="' + ids.join(',') + '" />' +
    '</form>')

    $('body').append(form)
    $(form).submit()

  toggleSelect: =>
    if $('.toggle').first().data('state') == 'select'
      @selectAll()
    else
      @deSelectAll()

  selectAll: ->
    $('.selector input').prop('checked', true)
    $('.toggle').data('state', 'deselect')
    $('.toggle a').html("De-select All")

  deSelectAll: ->
    $('.selector input').prop('checked', false)
    $('.toggle').data('state', 'select')
    $('.toggle a').html("Select All")

$ ->
  beta_signups = new BetaSignups()
  beta_signups.init()
