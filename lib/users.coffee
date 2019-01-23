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

    Template.friend_list.onCreated ->
        @autorun -> Meteor.subscribe 'users'

    Template.friend_list.helpers
        users: -> Meteor.users.find()


    Template.assigned_tasks.onCreated ->
        @autorun => Meteor.subscribe 'assigned_tasks'
    Template.assigned_tasks.events
    Template.assigned_tasks.helpers
        assigned_tasks: ->
            Docs.find
                assigned_ids:$in:[Meteor.userId()]


    Template.following.onCreated ->
        Meteor.subscribe 'my_following'


    Template.following.helpers
        following: ->
            me = Meteor.user()
            Docs.find
                follower_ids:$in:[me._id]