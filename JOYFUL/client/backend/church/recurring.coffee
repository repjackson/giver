Template.ChurchRecurringDetail.events {}
Template.ChurchRecurringDetail.helpers
  'newRecurrence': ->
    if @recurrence == 'bi-weekly'
      'every other week'
    else
      @recurrence
  'newAmount': ->
    numeral(@amount).format '$0,0.00'
  'churchName': ->
    Meteor.subscribe 'churchById', @church
    church = Meteor.users.findOne(@church)
    church.profile.churchName + ' - ' + church.profile.address.city
  'action': ->
    `var data`
    `var data`
    if @status == 'active'
      data =
        title: 'Pause Plan'
        style: 'success'
        class: 'pause_plan'
      data
    else if @status == 'canceled'
      data =
        title: 'Restart Plan'
        style: 'danger'
        class: 'start_plan'
      data
    else
      data =
        title: 'Restart Plan'
        style: 'danger'
        class: 'start_plan'
      data
Template.churchRecurring.onRendered ->
  $('#churchRecuringActiveDatatable').dataTable()
  $('#churchRecuringPauseDatatable').dataTable()