Template.church_menu.helpers
  ischurchAdmin: ->
    loggedInuserDet = Meteor.user()
    loggedinEmailId = readCookie('loggedinEmailId')
    if loggedInuserDet and loggedInuserDet.emails[0].address == loggedinEmailId
      true
    else
      false