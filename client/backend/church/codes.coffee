Template.churchCodes.events
  'click .generate': ->
    bootbox.prompt
      title: 'Is this for a specific campaign? (leave blank for general fund donations)'
      callback: (result) ->
        if result != null
          Meteor.call 'generateNewCode', Meteor.userId(), result
        return
    return
  'click .remove_code': (event) ->
    if @isActive
      bootbox.confirm 'Are you sure? This will mean new users won\'t be able to find you with this code.', (result) ->
        if result
          Meteor.call 'removeChurchCode', event.currentTarget.id
        return
    else
      bootbox.confirm 'Are you sure? This will mean users be able to find you with this code.', (result) ->
        if result
          Meteor.call 'removeChurchCode', event.currentTarget.id
        return
    return
  'click .addCustom': (event, template) ->
    Meteor.call 'addCustomCode', event.currentTarget.id
    return
Template.churchCodes.onRendered ->
  $('#churchCodesDatatable').dataTable()