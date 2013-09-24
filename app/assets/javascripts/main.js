var Lightbox = {
  init: function() {
    $("a[href$='.jpg'],a[href$='.png'],a[href$='.jpeg']").each(function() {
      $link = $(this);
      $images = $link.children('img[src="'+$link.attr("href")+'"]');
      if($images.length === 1) {
        $link.attr("title", $images.attr("title"));
        $(this).fancybox({
          padding: 0,
          helpers: {
            title: {
              type: 'over'
            }
          }
        });
      }
    });
  }
};

var Viewport = {
  getWidth: function() {
    var size = window.getComputedStyle(document.body,':after').getPropertyValue('content');
    return size.replace(/\"/g, "");
  }
};

var Calendar = {
  init: function() {
    $('#fullcalendar').html("").fullCalendar({
      events: {
        url: '/events.json',
        allDayDefault: false
      },
      firstDay: 1,
      timeFormat: 'h(:mm)tt',
      eventRender: function(event, element) {
        if(event.location.length) {
          element.tooltip({
            title: event.location,
            container: "body"
          });
        }
      }
    });
  }
};

var Results = {
  traceClass: "trace",

  clearTraces: function() {
    Results.ths.removeClass(Results.traceClass);
  },

  trace: function() {
    Results.clearTraces();
    Results.traceRow(this);
    Results.traceCol(this);
  },

  traceRow: function(cell) {
    $(cell).closest("tr").find("th").addClass(Results.traceClass);
  },

  traceCol: function(cell) {
    var cellIndex = $(cell).closest("tr").find("th,td").index(cell)+1;
    $(cell).closest("table").find("th:nth-child("+cellIndex+")").addClass(Results.traceClass);
  },

  collapseMisc: function() {
    $("#misc-results").addClass("collapsed");
    $("#misc-results h1").click(Results.expandParent);
  },

  expandParent: function() {
    $(this).closest(".collapsed").toggleClass("collapsed");
  },

  init: function() {
    Results.collapseMisc();
    Results.tables = $("#results table");

    if(!Results.tables) {
      return false;
    }

    Results.ths = Results.tables.find("th");
    Results.tables.mouseout(Results.clearTraces);
    Results.tables.find("td").hover(Results.trace);
  }
};

$(function() {
  Calendar.init();
  Results.init();

  if(Viewport.getWidth() === "wide") {
    Lightbox.init();
  }
});
