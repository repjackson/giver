Template.thanks.helpers
	'date': ->
		moment.unix(@tithe.date).format 'MM/DD/YYYY, h:mm a'
	'amount': ->
		numeral(@tithe.amount / 100).format '$0,0.00'
	'church': ->
		Meteor.users.findOne @tithe.church
	'ios': ->
		Session.get 'ios'

Template.thanks.events
	'click .createAccount': (event, template) ->
		Session.set 'registerTithe', template.data.tithe._id
		Router.go '/register/giver'