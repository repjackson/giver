Template.getchurches.helpers 'backPath': ->
  Session.get 'backPath'
Template.allChurchInfoHolder.events
  'click .give': (event, template) ->
    Session.set 'givingCode', template.data.code
    iosgivepageload template.data._id
    return
  'click .add': (event, template) ->
    code = event.currentTarget.id
    if code == 'name'
      code = null
    MyChurches.insert {
      church: template.data._id
      user: Meteor.userId()
      code: code
    }, (err, result) ->
      if err
        bootbox.alert 'There was an error adding this church. Please try again.'
      else
        bootbox.alert 'Your church has been added to your account.'