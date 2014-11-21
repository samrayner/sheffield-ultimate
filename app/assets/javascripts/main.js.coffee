class Viewport
  @getWidth: ->
    size = window
            .getComputedStyle(document.body,':after')
            .getPropertyValue('content')
    size.replace(/\"/g, '')

class Lightbox
  @init: ->
    $imageLinks = $("a[href$='.jpg'],a[href$='.png'],a[href$='.jpeg']")
      .filter ->
        $link = $(this)
        $images = $link.children('img[src="'+$link.attr("href")+'"]')
        if $images.length == 1
          $link.attr("title", $images.attr("title"))
        else
          false

    $imageLinks.fancybox
        padding: 0
        helpers:
          title:
            type: 'over'
          thumbs: $imageLinks.length > 1

class Calendar
  @init: ->
    $placeholder = $('#fullcalendar')
    calId = $placeholder.data("calendar-id")
    $placeholder.html("").fullCalendar
      googleCalendarApiKey: "AIzaSyCaiegXWqtrKqG4rDT9odrd-NyFKEc8MV8"
      events:
        googleCalendarId: calId
      firstDay: 1
      timeFormat: 'h(:mm)a'
      eventRender: (event, element) ->
        if event.location && event.location.length
          element.tooltip(title: event.location, container: "body")
        return
      eventClick: (event) ->
        if event.description && event.description.indexOf("http") == 0
          window.open(event.description)
          return false

        if event.location && event.location.length
          window.open("https://www.google.co.uk/maps/preview?q="+encodeURIComponent(event.location))
          return false

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

  results = new Results()
  results.init()

  Lightbox.init() if Viewport.getWidth() == "wide"
