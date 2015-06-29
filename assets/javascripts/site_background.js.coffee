class @SiteBackground
  @cookie: (name) ->
    cookies = (cookie.trim() for cookie in document.cookie.split(";"))
    for cookie in cookies when cookie.indexOf("#{name}=") is 0
      return cookie.substring("#{name}=".length)

  @loadFromParam: (background_element_id) ->
    index = @cookie('background_id')
    if index?
      @load(parseInt(index), background_element_id)
    else
      @loadRandom(background_element_id)

  @loadRandom: (background_element_id) ->
    SiteBackground.load(SiteBackground.randomIndex(), background_element_id)

  @load: (index, background_element_id) ->
    background = document.getElementById("background_" + index)
    if !background
      index = SiteBackground.randomIndex()
      background ||= document.getElementById("background_" + index)

    url = if document.querySelector("html").classList.contains('no-touch') then background.getAttribute('data-url') else background.getAttribute('data-small_url')
    credit_name = background.getAttribute('data-credit_name')
    window.f_home_background_url = url
    if background_element_id
      document.getElementById(background_element_id).style.backgroundImage = 'url(' + url + ')'
    else
      document.body.style.backgroundImage = 'url(' + url + ')'

    document.getElementById('background_credit_name').innerHTML = credit_name
    document.cookie = "background_id=" + index
    _kmq.push [
      'set'
      {
        'Background ID': credit_name + ' ' + index
      }
    ]

  @randomIndex: ->
    Math.floor(Math.random() * 3) + 1
