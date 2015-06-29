class @SocialAuth
  # Twitter
  @authorizeTwitter: (success, fail) ->
    @twitterCallbacks =
      success: success
      fail: fail

    left = screen.availWidth / 2 - 400
    window.open '/auth/twitter/authorize', 'social_auth', 'width=800,height=600,dialog,top=100,left=' + left

  @disableTwitter: (callback) ->
    $.get(
      '/auth/twitter/disable'
      null
      null
      'json'
    ).then( () ->
      callback.call(null)
    )

  @twitterStatus: (callback) ->
    $.get(
      '/auth/twitter/status'
      null
      null
      'json'
    ).then( (response) ->
      callback.call(null, response)
    )

  @twitterPost: (text, success, fail) ->
    $.post(
      '/auth/twitter/post'
      {text: text}
      null
      'json'
    ).then(
      (response) ->
        success.call(null, response)
        _kmq.push(['record', 'Posted to Twitter'])
      (response) ->
        fail.call(null, response)
    )

  @twitterSuccess: (tokens) ->
    @twitterCallbacks.success.call(null, tokens)

  @twitterFail: (error) ->
    @twitterCallbacks.fail.call(null, error)

  # Tumblr
  @authorizeTumblr: (success, fail) ->
    @tumblrCallbacks =
      success: success
      fail: fail

    left = screen.availWidth / 2 - 400
    window.open '/auth/tumblr/authorize', 'social_auth', 'width=800,height=600,dialog,top=100,left=' + left

  @disableTumblr: (callback) ->
    $.get(
      '/auth/tumblr/disable'
      null
      null
      'json'
    ).then( () ->
      callback.call(null)
    )

  @tumblrChooseBlog: (blog, callback) ->
    $.post(
      '/auth/tumblr/choose_blog'
      {blog: blog}
      null
      'json'
    ).then(
      (response) ->
        callback.call(null, response)
    )

  @tumblrStatus: (callback) ->
    $.get(
      '/auth/tumblr/status'
      null
      null
      'json'
    ).then(
      (response) ->
        callback.call(null, response)
    )

  @tumblrPost: (text, success, fail) ->
    $.post(
      '/auth/tumblr/post'
      {text: text}
      null
      'json'
    ).then(
      (response) ->
        success.call(null, response)
        _kmq.push(['record', 'Posted to Tumblr'])
      (response) ->
        fail.call(null, response)
    )

  @tumblrUserInfo: (success, fail) ->
    $.get(
      '/auth/tumblr/user_info'
      null
      null
      'json'
    ).then(
      (response) ->
        success.call(null, response)
      (response) ->
        fail.call(null, response)
    )

  @tumblrSuccess: (tokens) ->
    @tumblrCallbacks.success.call(null, tokens)

  @tumblrFail: (error) ->
    @tumblrCallbacks.fail.call(null, error)

  # Facebook
  @authorizeFacebook: (success, fail) ->
    @facebookCallbacks =
      success: success
      fail: fail

    left = screen.availWidth / 2 - 400
    window.open '/auth/facebook/authorize', 'social_auth', 'width=800,height=600,dialog,top=100,left=' + left

  @disableFacebook: (callback) ->
    $.get(
      '/auth/facebook/disable'
      null
      null
      'json'
    ).then( () ->
      callback.call(null)
    )

  @facebookSetAccount: (access_token, name, id, callback) ->
    $.post(
      '/auth/facebook/set_account'
      {access_token: access_token, name: name, id: id}
      null
      'json'
    ).then(
      (response) ->
        callback.call(null, response)
    )

  @facebookStatus: (callback) ->
    $.get(
      '/auth/facebook/status'
      null
      null
      'json'
    ).then( (response) ->
      callback.call(null, response)
    )

  @facebookGetObject: (path, success, fail) ->
    $.get(
      '/auth/facebook/get_object'
      {
        path: path
      }
      null
      'json'
    ).then(
      (response) ->
        success.call(null, response)
      (response) ->
        fail.call(null, response.responseJSON)
    )

  @facebookPost: (text, success, fail) ->
    $.post(
      '/auth/facebook/post'
      {text: text}
      null
      'json'
    ).then(
      (response) ->
        success.call(null, response)
        _kmq.push(['record', 'Posted to Facebook'])
      (response) ->
        fail.call(null, response)
    )

  @facebookSuccess: (tokens) ->
    @facebookCallbacks.success.call(null, tokens)

  @facebookFail: (error) ->
    @facebookCallbacks.fail.call(null, error)

