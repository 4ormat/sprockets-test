$ ->
  $mapEl = $(".map-canvas")
  $registerBtn = $(".js-register-btn")
  geocoder = new google.maps.Geocoder()
  eventLocation = "234 Bay St., Toronto, ON, Canada"
  coords = null
  map = null
  marker = null
  geocoder.geocode({
    'address': eventLocation
  }, (results, status) ->
    coords = results[0].geometry.location
    mapOptions =
      center: coords
      zoom: 18
      mapTypeId: google.maps.MapTypeId.ROADMAP
      disableDefaultUI: true
      scrollwheel: false
    map = new google.maps.Map($mapEl[0], mapOptions)
    marker = new google.maps.Marker(
      position: coords
      map: map
      icon: $mapEl.attr("data-marker")
    )
    marker.setMap map
    google.maps.event.addDomListener window, 'resize', ->
      map.setCenter coords
  )
  $("body").on "click", ".nvite-rsvp-widget-options-button", (e) ->
    $("body").addClass("scroll-lock")
    setTimeout ->
      $(".nvite-modal-close").on "click", (e) ->
        $("body").removeClass("scroll-lock")
    , 0
  $(window).load ->
    if $(".nvite-rsvp-widget-button").hasClass("nvite-rsvp-widget-button-success")
      $registerBtn.html("<span class='ss-icon'>check</span> We'll be in touch").addClass("attending")
      $(".nvite-widget-wrapper").addClass("attending")
    $registerBtn.removeClass("hidden");





