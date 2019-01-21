Template.userChurches.helpers 'churches': ->
  Meteor.subscribe 'myChurches', Meteor.userId()
  Meteor.subscribe 'myChurchData', Meteor.userId()
  MyChurches.find({ user: Meteor.userId() }, fields: church: 1).fetch()
Template.churchInfoNew.helpers
  'ch': ->
    Meteor.users.findOne @church
Template.churchInfoNew.events
  'click .remove': (event, template) ->
    bootbox.confirm 'Are you sure you want to remove this Organization?', (result) ->
      if result
        Meteor.call 'RemoveMyChurch', Meteor.userId(), template.data.church, ->
          Meteor.subscribe 'myChurches', Meteor.userId()

  'click .give': (event, template) ->
    Router.go 'give', id: template.data.church
