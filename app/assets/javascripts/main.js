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
  table: $("#results table"),
  ths: null,

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

    if(!Results.table) {
      return false;
    }
    
    Results.ths = Results.table.find("th");
    Results.table.mouseout(Results.clearTraces);
    Results.table.find("td").hover(Results.trace);
  }
};

$(function() {
  Calendar.init();
  Results.init();
});
