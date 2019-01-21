Template.userDashboard.helpers 'total': ->
  start = moment().startOf('year').format('X')
  end = moment().endOf('month').format('X')
  amt = Tithes.find(date:
    $lte: end
    $gte: start).sum('amount')
  numeral(amt / 100).format '$0,0'
Template.userDashboard.events 'click .viewTour': (event, template) ->
  Meteor.call 'toggleUserTour'