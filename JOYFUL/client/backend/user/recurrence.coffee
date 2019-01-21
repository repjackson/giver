Template.recurringDetail.events
  'click .pause_plan': (event) ->
    id = event.currentTarget.id
    Meteor.call 'updateTithePlanStatus', id, 'paused'
    return
  'click .start_plan': (event) ->
    id = event.currentTarget.id
    Meteor.call 'updateTithePlanStatus', id, 'active'
    return
Template.recurringDetail.helpers
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
Template.recurringDetailWell.events
  'click .pause_plan': (event) ->
    id = event.currentTarget.id
    Meteor.call 'updateTithePlanStatus', id, 'paused'
    return
  'click .start_plan': (event) ->
    id = event.currentTarget.id
    Meteor.call 'updateTithePlanStatus', id, 'active'
    return
Template.recurringDetailWell.helpers
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
Template.user_recurring.onRendered ->
  $('#user_recurringActiveDatatable').dataTable()
  $('#user_recurringPauseDatatable').dataTable()
  $('#user_recurringCancelDatatable').dataTable()
  return

# ---
# generated by js2coffee 2.2.0