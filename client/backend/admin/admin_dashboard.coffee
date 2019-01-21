eventData = {}
data = []
Template.adminDashboard.onRendered ->
  Result = []
  Tracker.autorun ->
    Result = requestDemo.find({}).fetch()
    data = []
    Result.forEach (d, i) ->
      FormattedResult = {}
      FormattedResult['start'] = d.date
      FormattedResult['title'] = d.firstName + ' ' + d.lastName
      FormattedResult['id'] = d._id
      data.push FormattedResult
      return
    $('#calendar').fullCalendar 'removeEvents'
    $('#calendar').fullCalendar 'addEventSource', data
    $('#calendar').fullCalendar 'rerenderEvents'
    $('.fc-time').hide()

  $('#calendar').fullCalendar
    customButtons:
      prevButton:
        icon: 'left-single-arrow'
        click: ->
          $('#calendar').fullCalendar 'prev'
          $('.fc-time').hide()

      nextButton:
        icon: 'right-single-arrow'
        click: ->
          $('#calendar').fullCalendar 'next'
          $('.fc-time').hide()

    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    defaultDate: new Date
    editable: true
    eventLimit: true
    selectable: true
    selectHelper: true
    events: data
    eventClick: (calEvent, jsEvent, view) ->
      eventData =
        _id: calEvent._id
        id: calEvent.id
        title: calEvent.title
        date: calEvent.date
      bootbox.prompt
        title: 'change the schedule of demo'
        inputType: 'date'
        callback: (result) ->
          if result
            Meteor.call 'demoRescheduledMethod', eventData.id, result
            $('#calendar').fullCalendar 'removeEvents', eventData._id
            $('#calendar').fullCalendar 'renderEvent', {
              title: eventData.title
              start: new Date(result)
            }, true
            $('.fc-time').hide()
          return
      $('.bootbox-input-date').val moment(calEvent.start._d).format('YYYY-MM-DD')
      return
  $('.fc-time').hide()
  $('#requestDemoDatatable').dataTable()

Template.adminDashboard.helpers formatDate: (date) ->
  moment(date).format 'MM/DD/YYYY hh:mm a'
Template.adminDashboard.events 'click #isComplete': (e, t) ->
  e.preventDefault()
  bootbox.confirm
    message: 'Are you sure for demo was completed?'
    buttons:
      confirm:
        label: 'Yes'
        className: 'btn-success'
      cancel:
        label: 'No'
        className: 'btn-warning'
    callback: (result) ->
      if result
        id = $(e.currentTarget).attr('data-id')
        Meteor.call 'democompletedMethod', id