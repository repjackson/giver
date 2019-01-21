Router.map ->
	@route 'dashboard',
		path: '/dashboard'
		layoutTemplate: 'layout'
		onBeforeAction: ->
			if Meteor.userId()
				if Roles.userIsInRole(Meteor.userId(), 'user')
					@redirect '/user/dashboard'
					@next()
				if Roles.userIsInRole(Meteor.userId(), 'church')
					@redirect '/church/dashboard'
					@next()
				if Roles.userIsInRole(Meteor.userId(), 'admin')
					@redirect '/admin/dashboard'
					@next()
			else
				@redirect '/login'
				@next()

	@route 'church_dashboard',
		path: '/church/dashboard'
		layoutTemplate: 'layout'
		onBeforeAction: ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@redirect '/signin'
			else
				@next()
			return
		waitOn: ->
			start = moment().startOf('year').format('X')
			end = moment().endOf('month').format('X')
			[
				Meteor.subscribe('TitheTotals', Meteor.userId(), start, end)
				Meteor.subscribe('dailyTithesReport')
				Meteor.subscribe('ChurchCodes', Meteor.userId())
			]
		data: ->
			templateData = codes: ChurchCodes.find(church: Meteor.userId())
			templateData

	@route 'userDashboard',
		path: '/user/dashboard'
		layoutTemplate: 'layout'
		onBeforeAction: ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@redirect '/signin'
			else
				@next()
			return

		waitOn: ->
			start = moment().startOf('year').format('X')
			end = moment().endOf('month').format('X')
			[ Meteor.subscribe('UserTitheTotals', Meteor.userId(), start, end) ]

	@route 'adminDashboard',
		path: '/admin/dashboard'
		layoutTemplate: 'layout'
		onBeforeAction: ->
			if Roles.userIsInRole(Meteor.userId(), 'superadmin') or Roles.userIsInRole(Meteor.userId(), 'admin')
				@next()
			else
				@redirect '/dashboard'
				@next()
			return
		waitOn: ->
			[ Meteor.subscribe('demoRequestList') ]
		data: ->
			{ requestDemoData: requestDemo.find({}).fetch() }