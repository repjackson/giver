Template.search.helpers
	'backPath': ->
		Session.get 'backPath'

Template.churchInfoHolder.events
	'click .give': (event, template) ->
		Session.set 'givingCode', template.data.code
		iosgivepageload template.data._id
	'click .add': (event, template) ->
		code = event.currentTarget.id
		if code == 'name'
			code = null
		Meteor.call 'addMyChurches', template.data._id, code, (err, res) ->
			if err
				alert 'There was an error adding this church. Please try again.'
			else
				alert 'This organization has been added to your account.'

Template.campaignInfo.helpers 'church': ->
	church = Meteor.users.findOne(@church)
	church.profile

Template.campaignInfo.events 'click .give': (event, template) ->
	Session.set 'givingCode', template.data.code
	console.log 'entered ioscamppageload...'
	#Router.go('/'+template.data.code)
	ioscamppageload template.data.code
