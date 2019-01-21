Template.userReceipt.helpers
  'date': ->
    moment.unix(@tithe.date).format 'MM/DD/YYYY, h:mm a'
  'amount': ->
    numeral(@tithe.amount / 100).format '$0,0.00'
  'church': ->
    Meteor.users.findOne @tithe.church
  'giver': ->
    user = Meteor.users.findOne(_id: @tithe.userID)
    if user.profile.name
      user.profile.name
    else
      user.profile.firstname + ' ' + user.profile.lastname
Template.userReceipt.onRendered ->
  hideLoadingMask()
  return
