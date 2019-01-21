Template.churchShowConnect.helpers
  'show_register': ->
    profile = Meteor.user().profile
    if !profile
      true
    else
      if profile.stripe
        false
      else
        true
  'SETTINGS': (options) ->
    data = Session.get('SETTINGS')
    data[options.hash.id]
  'SETTINGS_old': (options) ->
    Meteor.call 'PUBLIC_SETTINGS', (err, response) ->
      setting = response[options.hash.id]
      setting