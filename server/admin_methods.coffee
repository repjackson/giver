Meteor.methods
	makeAdmin: (password, code, user) ->
		result = {}
		if password == SERVER_SETTINGS.makeAdminPW
			if code == SERVER_SETTINGS.makeAdminCODE
				result.pass = true
				Roles.addUsersToRoles user, 'admin'
				Roles.removeUsersFromRoles user, 'user'
			else
				result.error = 'Admin CODE is Not Correct'
		else
			result.error = 'Admin Password is Not Correct'
		result
	checkCreateAdmin: ->
		users = Meteor.users.find(roles: 'admin')
		if users.count() < 1
			try
				id = Accounts.createUser(
					email: 'admin@joyful-giver.com'
					password: 'zimbatdrs2010'
					profile: {})
				Roles.addUsersToRoles id, 'admin'
				console.log Meteor.users.findOne(username: 'admin@joyful-giver.com')
			catch err
				console.log err
		return
	loginAs: (currentUser, user) ->
		if Roles.userIsInRole(currentUser, 'admin')
			console.log 'switching user account'
			console.log Accounts.impSvc.set(user)
			return Accounts.impSvc.set(user)
		else
			console.log 'user account switch blocked - must be superadmin'
		return
	democompletedMethod: (id) ->
		requestDemo.update { _id: id }, $set: 'status': 'confirm'
	demoRescheduledMethod: (id, date) ->
		requestDemo.update { _id: id }, $set: 'date': date
	enable_disable_account: (id, type) ->
		if type == 'disable_account'
			Meteor.users.update { _id: id }, $set: 'profile.isActive': false
		else
			Meteor.users.update { _id: id }, $set: 'profile.isActive': true
	checkChurchUser: (emailId) ->
		userDet = Meteor.users.findOne('emails.address': emailId)
		if !userDet.profile.isActive
			return {
				'msg': 'Your account suspended please contact Joyful Giver admin on info@joyful-giver.com'
				'statusCode': false
			}
		if userDet.emails.length > 1
			userFilter = userDet.filter((obj) ->
				obj.address == emailId
			)
			if userFilter[0].role == 'churchUser'
				{
					'msg': 'you have not rights Please Contact ' + userDet[0].address
					'statusCode': false
				}
			else
				{
					'msg': 'User is church admin'
					'statusCode': true
				}
		else
			{
				'msg': 'User is church admin'
				'statusCode': true
			}

	checkChurchUserExist: (emailId) ->
		userDet = Meteor.users.findOne('emails.address': emailId)
		if userDet
			{ 'statusCode': false }
		else
			{ 'statusCode': true }

	enableDisableJGFees: (id, type) ->
		if type == 'disableFees'
			Meteor.users.update { _id: id }, $set: 'profile.isJGFeesApply': false
		else
			Meteor.users.update { _id: id }, $set: 'profile.isJGFeesApply': true
	saveAppSettings: (id, data) ->
		AppSettings.update id, $set: data
		return
		# getChurchCampaignDetail: (sortBY) ->
		#   allThithesTotal = Tithes.aggregate([
		#     { '$group':
		#       _id: churchCODE: '$churchCODE'
		#       amount: $sum: '$amount' }
		#     { '$sort': 'amount': sortBY }
		#   ])
		#   tithesCampaigns = []
		#   if sortBY == 1
		#     campaignCodes = []
		#     allThithesTotal.forEach (d, i) ->
		#       campaignCodes.push d._id.churchCODE
		#       return
		#     churchCodeArray = ChurchCodes.find(
		#       isActive: true
		#       code: $nin: campaignCodes
		#       'Goal_Donation': $exists: true
		#       'customPage': $exists: true
		#       'customPage.header_image': $exists: true).fetch()
		#     churchCodeArray.forEach (churchCodeDet, i) ->
		#       if tithesCampaigns.length == 12
		#         return tithesCampaigns
		#       tithesCampaignsJson = {}
		#       tithesCampaignsJson['code'] = churchCodeDet.code
		#       tithesCampaignsJson['campaign'] = churchCodeDet.campaign
		#       tithesCampaignsJson['header_image'] = churchCodeDet.customPage.header_image
		#       # tithesCampaignsJson['textContent'] = churchCodeDet.customPage.textContent.substring(0,200);
		#       tithesCampaignsJson['Goal_Donation'] = churchCodeDet.Goal_Donation
		#       tithesCampaignsJson['raised'] = 0
		#       tithesCampaigns.push tithesCampaignsJson
		#       return
		allThithesTotal.forEach (d, i) ->
			if tithesCampaigns.length == 3 and sortBY == -1
				return tithesCampaigns
			if tithesCampaigns.length == 12 and sortBY == 1
				return tithesCampaigns
			if d._id.churchCODE != null
				churchCodeDet = ChurchCodes.findOne(
					code: d._id.churchCODE
					'Goal_Donation': $exists: true
					'customPage': $exists: true
					'customPage.header_image': $exists: true
					'customPage.textContent': $exists: true)
				if churchCodeDet
					tithesCampaignsJson = {}
					tithesCampaignsJson['code'] = churchCodeDet.code
					tithesCampaignsJson['campaign'] = churchCodeDet.campaign
					tithesCampaignsJson['header_image'] = churchCodeDet.customPage.header_image
					tithesCampaignsJson['textContent'] = churchCodeDet.customPage.textContent.substring(0, 200)
					tithesCampaignsJson['Goal_Donation'] = churchCodeDet.Goal_Donation
					tithesCampaignsJson['raised'] = d.amount
					tithesCampaigns.push tithesCampaignsJson
			return
		tithesCampaigns

	appStatics: ->
		amt = 0
		Tithes.find({}).forEach (d, i) ->
			amt += d.amount
			return
		churchCount = Meteor.users.find(roles: 'church').count()
		userCount = Meteor.users.find(roles: 'user').count()
		campaignCount = ChurchCodes.find({}).count()
		# return {
		#   churchCount : churchCount,
		#   userCount:userCount,
		#   campaignCount:campaignCount,
		#   amount:(amt / 100)
		# }
		{
			churchCount: 8500
			userCount: 350000
			campaignCount: 16000
			amount: 750000
		}

	sendFeedbackToAdmin: (data) ->
		html = '<table>' + '<tr>' + '<th>PERSON NAME : </th>' + '<td>' + data.name + '</td>' + '</tr>' + '<tr>' + '<th>EMAIL Address : </th>' + '<td>' + data.email + '</td>' + '</tr>' + '<tr>' + '<th>EXPERIENCE : </th>' + '<td>' + data.experience + '</td>' + '</tr>' + '<tr>' + '<th>Feedback : </th>' + '<td>' + data.comments + '</td>' + '</tr>' + '<tr>' + '<th>DATE : </th>' + '<td>' + moment().format('MMM DD YYYY') + '</td>' + '</tr>' + '</table>'
		SSR.compileTemplate 'emailText', html
		emailObj =
			to: 'info@joyful-giver.com'
			subject: 'Feedback submitted by user'
		emailObj['html'] = SSR.render('emailText')
		emailObj['from'] = 'info@joyful-giver.com'
		Email.send emailObj




