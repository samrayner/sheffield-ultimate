class FluidVideos
  constructor: ->
  @init: (container="body", $videos=null) ->
    $videos ||= $("iframe[src*='vimeo.com'], iframe[src*='youtube.com']")

    $videos.each ->
      $(this)
        .data('aspectRatio', this.height/this.width)
        .removeAttr('height')
        .removeAttr('width')

    $(window).resize ->
      newWidth = $(container).width()
      $videos.each ->
        $elm = $(this)
        $elm
          .width(newWidth)
          .height(newWidth * $elm.data('aspectRatio'))

    $(window).resize()

class Viewport
  constructor: ->
  @getWidth: ->
    size = window
            .getComputedStyle(document.body,':after')
            .getPropertyValue('content')
    size.replace(/\"/g, '')

class Lightbox
  constructor: ->
  @init: ->
    $("a[href$='.jpg'],a[href$='.png'],a[href$='.jpeg']").each ->
      $link = $(this)
      $images = $link.children('img[src="'+$link.attr("href")+'"]')
      if $images.length == 1
        $link.attr("title", $images.attr("title"))
        $(this).fancybox({
          padding: 0,
          helpers: {
            title: {
              type: 'over'
            }
          }
        })

class Calendar
  constructor: ->
  @init: ->
    $('#fullcalendar').html("").fullCalendar({
      events: {
        url: '/events.json',
        allDayDefault: false
      },
      firstDay: 1,
      timeFormat: 'h(:mm)tt',
      eventRender: (event, element) ->
        if event.location.length
          element.tooltip(title: event.location, container: "body")
        return
    })

class Results
  constructor: (@traceClass="trace", @collapsedClass="collapsed") ->
    @$tables = $("#results table")
    @$ths = @$tables.find("th")

  clearTraces: =>
    @$ths.removeClass(@traceClass)

  trace: (e) =>
    @clearTraces()
    @traceRow(e.currentTarget)
    @traceCol(e.currentTarget)

  traceRow: (cell) ->
    $(cell).closest("tr").find("th").addClass(@traceClass)

  traceCol: (cell) ->
    cellIndex = $(cell).closest("tr").find("th,td").index(cell)+1
    $(cell).closest("table").find("th:nth-child("+cellIndex+")").addClass(@traceClass)

  collapseMisc: ->
    $("#misc-results").addClass(@collapsedClass)
    $("#misc-results h1").click(@expandParent)

  expandParent: (e) =>
    $(e.currentTarget).closest("."+@collapsedClass).toggleClass(@collapsedClass)

  init: ->
    @collapseMisc()

    return false unless @$tables.length

    @$tables.mouseout(@clearTraces)
    @$tables.find("td").hover(@trace)

$ ->
  Calendar.init()
  FluidVideos.init()

  results = new Results()
  results.init()

  Lightbox.init() if Viewport.getWidth() == "wide"
