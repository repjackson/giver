Template.getcampaigns.helpers 'backPath': ->
	Session.get 'backPath'
Template.allCampaignInfo.helpers 'church': ->
	churchId = @church
	church = Meteor.users.find(churchId)
	console.log this
	console.log church
	church.profile
Template.allCampaignInfo.events 'click .give': (event, template) ->
	Session.set 'givingCode', @code
	console.log 'entered allCampaignInfo give... ', @code
	ioscamppageload @code