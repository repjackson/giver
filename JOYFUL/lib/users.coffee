if Meteor.isClient
	Template.admin_users.helpers
		users: -> Meteor.users.find()
	Template.admin_users.onCreated ->
		@autorun -> Meteor.subscribe 'admin_users'
	Template.admin_users.events
		'click .clean_email': ->
			if confirm 'Confirm clean emails'
				Meteor.call 'clean_mail'
		'click .disable_account': (event, template) ->
			self = this
			if confirm 'Confirm disable account'
				Meteor.call 'enable_disable_account', self._id, 'disable_account', (err, data) ->
					if data
						alert 'User account disabled'
		'click .enable_account': (event, template) ->
			self = this
			if confirm 'Confirm enable account'
				Meteor.call 'enable_disable_account', self._id, 'enable_account', (err, data) ->
					if data
						alert 'User account enabled'
