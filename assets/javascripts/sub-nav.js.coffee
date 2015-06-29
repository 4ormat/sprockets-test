class @SubNav
  init: =>
    @handleResize()
    @mobileSubNav()
    $(window).on "scroll", @handleScroll

  handleResize: =>
    windowHeight = $(window).height()
    @subNav().css(
      top: @homeHeader().outerHeight()
    )

  handleScroll: =>
    scrollTop = $(document).scrollTop()
    if ((scrollTop + @homeHeaderHeight()) >= @mainSection().offset().top) and (!@subNav().hasClass('open'))
      @subNav().addClass('sticky')
    else
      @subNav().removeClass('sticky')

  mobileSubNav: =>
    $('.sub-nav').click( ->
      $('.sub-nav').toggleClass 'open'
      return
    ).children('.dropdown a').click (e) ->
      false

    $('.sub-nav a').on 'click', ->
      $('.sub-nav').removeClass 'open'

  # DOM Elements
  mainSection: =>
    $("main")

  homeHeader: =>
    $(".home-header")

  homeHeaderHeight: =>
    @homeHeader().outerHeight()

  subNav: =>
    $(".sub-nav")

  subNavHeight: =>
    @subNav().outerHeight()

  subNavTopOffset: =>
    $(".sub-nav").offset().top

  subNavWrapper: =>
    $(".sub-nav-wrapper")

  firstSection: =>
    $("section:first-child")

  initialScrollOffset: =>
    28

class @ScrollSpySubNav extends SubNav
  constructor: (@sections) ->
    super()

  init: =>
    super()
    @bindEvents()

  bindEvents: =>
    @subNav().find('a').on 'click', @scrollTo

  scrollTo: (e) =>

    e.preventDefault()
    id = $(e.currentTarget).attr('data-target')

    if @firstSection().hasClass(id)
      scrollPos = $("section[data-id=#{id}]").offset().top - @subNavHeight() + @initialScrollOffset()
    else if @subNavHeight() > 80
      scrollPos = $("section[data-id=#{id}]").offset().top - @initialScrollOffset()
    else
      scrollPos = $("section[data-id=#{id}]").offset().top - ( @subNavHeight() + @homeHeaderHeight()) + @initialScrollOffset()



    $('html,body').stop().animate(
      scrollTop: scrollPos
    , 300)

  handleScroll: =>
    super()
    @sections.each (i, el) =>
      id = $(el).attr('data-id')
      topPos = $(el).offset().top
      if scrollTop >= (topPos - ( @subNav().outerHeight() + @homeHeaderHeight()) )
        @subNav().find("a").removeClass('active')
        @subNav().find("a[data-target=#{id}]").addClass('active')

class @FilterSubNav extends SubNav
  constructor: (@target) ->
    super()

  init: =>
    super()
    @bindEvents()

  bindEvents: =>
    @subNav().find('a').on 'click', @filterItems

  filterItems: (e) =>
    e.preventDefault()
    @setActiveNavItem( $(e.currentTarget) )
    predicate = $(e.currentTarget).attr("data-filter")
    if predicate is "*"
      @showItem( @target )
    else
      toShow = @target.filter ->
        categories = $(@).attr("data-filter").split(" ")
        if $.inArray(predicate, categories) > -1
          return $(@)
      @hideItem( @target )
      @showItem( toShow )

  setActiveNavItem: (item) =>
    @subNav().find("a").removeClass("active")
    item.addClass("active")

  showItem: (item) =>
    item.removeClass("filter_hidden")

  hideItem: (item) =>
    item.addClass("filter_hidden")







