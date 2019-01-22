Router.configure
	layoutTemplate: 'layout'
	notFoundTemplate: 'notFound'
	trackPageView: true


Router.map ->
	@route 'logout',
		path: '/logout'
		layoutTemplate: 'layout'
		onBeforeAction: (pause) ->
			document.cookie = 'loggedinEmailId=; expires=' + new Date + ';'
			Meteor.logout()
			@redirect '/'

	@route 'church_detail_public',
		path: '/churchDetail/:_id'
		layoutTemplate: false
		waitOn: ->
			[ Meteor.subscribe('church_detail_public', @params._id) ]
		data: ->
			templateData = churchDet: Meteor.users.findOne(_id: @params._id)
			templateData
	# @route 'resetPassword',
	# 	path: '/reset-password/:token'
	# 	fastRender: true
	# 	layoutTemplate: false
	# 	data: ->
	# 		Session.set 'resetPassword', @params.token
	@route 'select_role',
		path: '/select-role'
		fastRender: true
		layoutTemplate: false


Router.route '/mobile_search', -> @render 'mobile_search'
Router.route '/reset-password/:token', -> @render 'reset-password'
Router.route '/forgot-password', -> @render 'forgot_password'

Router.route '/', -> @render 'front'
Router.route '/login', -> @render 'login'
Router.route '/register', -> @render 'register'
Router.route '/register/church', -> @render 'register_church'
Router.route '/register/nonprofits', -> @render 'register_nonprofits'
Router.route '/register/giver', -> @render 'register_giver'
Router.route '/demo', -> @render 'demo'


# Router.map ->
	# @route 'customLanding',
	# 	path: '/:code'
	# 	layoutTemplate: 'layout'
	# 	waitOn: ->
	# 		console.log 'subs called'
	# 		[
	# 			Meteor.subscribe('oneCode', @params.code.toUpperCase())
	# 			Meteor.subscribe('oneChurchByCode', @params.code.toUpperCase())
	# 			Meteor.subscribe('myCards', Meteor.userId())
	# 		]
	# 	data: ->
	# 		templateData = code: @params.code.toUpperCase()
	# 		templateData
	# return
Router._filters = resetScroll: ->
	scrollTo = window.currentScroll or 0
	$('body').scrollTop scrollTo
	$('body').css 'min-height', 0
	return
filters = Router._filters
if Meteor.isClient
	Router.onAfterAction filters.resetScroll
	# for all pages



Router.route 'user_tithes', ->
	@render 'user_tithes'
	path: '/user_tithes'
	layoutTemplate: 'layout'
	waitOn: ->
		[ Meteor.subscribe('myTithes', Meteor.userId()) ]
	data: ->
		templateData = tithes: Tithes.find({ userID: Meteor.userId() }, sort: date: -1)
		templateData

Router.route 'iosAuth', ->
	path: '/auth/:token/rr/:_id'
	layoutTemplate: 'layout'
	onAfterAction: ->
		Meteor.loginWithToken @params.token, ->
			Session.set 'ios', true
			#Router.go('/give/'+this.params._id)
			iosgivepageload @params._id

Router.route 'user_recurring', ->
	@render 'user_recurring'
	path: '/user_recurring'
	layoutTemplate: 'layout'
	waitOn: ->
		[ Meteor.subscribe('myPlans', Meteor.userId()) ]
	data: ->
		templateData =
			active: TithePlans.find({
				userID: Meteor.userId()
				status: 'active'
			}, sort: amount: -1)
			paused: TithePlans.find({
				userID: Meteor.userId()
				status: 'paused'
			}, sort: amount: -1)
			canceled: TithePlans.find({
				userID: Meteor.userId()
				status: 'canceled'
			}, sort: amount: -1)
			count: TithePlans.find(
				userID: Meteor.userId()
				status: $in: Array('paused', 'active')).count()
		templateData


Router.route 'editRecurring', ->
		path: '/plan/:id'
		layoutTemplate: 'layout'
		waitOn: ->
			[
				Meteor.subscribe('onePlan', @params.id)
				Meteor.subscribe('planCharges', @params.id)
				Meteor.subscribe('myCards', Meteor.userId())
			]
		data: ->
			templateData =
				plan: TithePlans.findOne(@params.id)
				tithes: Tithes.find(plan: @params.id)
			templateData

Router.route 'userChurches', ->
	path: '/mychurches'
	layoutTemplate: 'layout'
	waitOn: ->
		[ Meteor.subscribe('myChurches', Meteor.userId()) ]

Router.route 'userReceipt', ->
	path: '/receipt/:id'
	layoutTemplate: 'receiptLayout'
	waitOn: ->
		[ Meteor.subscribe('TitheDetails', @params.id) ]
	data: ->
		templateData = tithe: Tithes.findOne(@params.id)
		templateData

Router.route '/user_reports', ->
	@render 'user_reports',
		waitOn: ->
			Meteor.subscribe 'userReportPub'

Router.route 'user_profile', ->
	path: '/user/profile/:_id'
	layoutTemplate: 'layout'
	waitOn: ->
		Meteor.subscribe 'userProfilePub', @params._id

Router.route '/account', ->
	console.log 'account'
	@render 'account'
	# waitOn: ->
	# 	[ Meteor.subscribe('myCards', Meteor.userId()) ]
	# data: ->
	# 	templateData =
	# 		profile: Meteor.users.find(Meteor.userId())
	# 		cards: MyCards.find(user: Meteor.userId())
	# 	templateData


Router.map ->
	@route 'churchTithes',
		path: '/church/tithes'
		layoutTemplate: 'layout'
		onBeforeAction: (pause) ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@render '/signin'
			else
				@next()
			return
		waitOn: ->
			[ Meteor.subscribe('churchTithes', Meteor.userId()) ]
		data: ->
			templateData = tithes: Tithes.find({ church: Meteor.userId() }, sort: date: -1)
			templateData
	@route 'churchRecurring',
		path: '/church/recurring'
		layoutTemplate: 'layout'
		onBeforeAction: (pause) ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@render '/signin'
			else
				@next()
			return
		waitOn: ->
			[ Meteor.subscribe('churchPlans', Meteor.userId()) ]
		data: ->
			templateData =
				active: TithePlans.find({
					church: Meteor.userId()
					status: 'active'
				}, sort: amount: -1)
				paused: TithePlans.find({
					church: Meteor.userId()
					status: 'paused'
				}, sort: amount: -1)
				canceled: TithePlans.find({
					church: Meteor.userId()
					status: 'canceled'
				}, sort: amount: -1)
				count: TithePlans.find(
					church: Meteor.userId()
					status: $in: Array('paused', 'active')).count()
			templateData
	@route 'churchCodes',
		path: '/church/codes'
		layoutTemplate: 'layout'
		onBeforeAction: (pause) ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@render '/signin'
			else
				@next()
			return
		waitOn: ->
			[ Meteor.subscribe('ChurchCodes', Meteor.userId()) ]
		data: ->
			templateData = codes: ChurchCodes.find(church: Meteor.userId())
			templateData
	@route 'churchCustomPage',
		path: '/church/custom-page/:id'
		layoutTemplate: 'layout'
		onBeforeAction: (pause) ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@render '/signin'
			else
				@next()
			return
		waitOn: ->
			[ Meteor.subscribe('ChurchCodes', Meteor.userId()) ]
		data: ->
			templateData =
				code: ChurchCodes.findOne(@params.id)
				uploader: new (Slingshot.Upload)('myFileUploads')
			templateData
	@route 'churchReports',
		path: '/church/reports'
		layoutTemplate: 'layout'
		onBeforeAction: (pause) ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@render '/signin'
			else
				@next()
			return
		waitOn: ->
			Meteor.subscribe 'ChurchReportPub'


	@route 'church_account',
		path: '/church/account'
		layoutTemplate: 'layout'
		onBeforeAction: (pause) ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@render '/signin'
			else
				@next()


	@route 'churchConnect',
		path: '/church/connect'
		onBeforeAction: (pause) ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@render '/signin'
			else
				if @params.query.error
					console.log @params.query.error
				else
					Meteor.call 'stripeChurchAuth', @params.query.code, Meteor.userId()
					@redirect '/church/dashboard'
				@next()


	@route 'churchUsers',
		path: '/church/addUsers'
		layoutTemplate: 'layout'
		onBeforeAction: (pause) ->
			loggedInUser = Meteor.user()
			if !loggedInUser
				@render '/signin'
			else
				@next()



Router.map ->
    @route 'smssigninup',
        path: '/SMS/reg'
        layoutTemplate: 'receiptLayout'
        data: ->
            templateData =
                phone: @params.query.p
                code: @params.query.c
            templateData
    @route 'smsaddphone',
        path: '/SMS/phone'
        layoutTemplate: 'receiptLayout'
        waitOn: ->
            Meteor.call 'updatePhoneNo', Session.get('phone')
            [ Meteor.subscribe('myCards', Meteor.userId()) ]
        data: ->
            cards = MyCards.find(user: Meteor.userId())
            templateData =
                phone: Session.get('phone')
                code: Session.get('code')
                cards: cards
                cardCount: cards.count()
            templateData


Router.map ->
    @route 'appSettings',
        path: '/admin/settings'
        layoutTemplate: 'layout'
        data: ->
            templateData = config: AppSettings.findOne()
            templateData
        onBeforeAction: ->
            if Roles.userIsInRole(Meteor.user(), 'superadmin') or Roles.userIsInRole(Meteor.userId(), 'admin')
                @next()
            else
                @redirect '/dashboard'
                @next()


    @route 'makeAdmin',
        path: '/admin/create'
        layoutTemplate: 'layout'

    @route 'admin_churches',
        path: '/admin/churches'
        layoutTemplate: 'layout'
        waitOn: ->
            [ Meteor.subscribe('admin_churches') ]
        data: ->
            templateData = churches: Meteor.users.find(roles: 'church')
            templateData
        onBeforeAction: ->
            if Roles.userIsInRole(Meteor.user(), 'superadmin') or Roles.userIsInRole(Meteor.userId(), 'admin')
                @next()
            else
                @redirect '/dashboard'


    @route 'adminReports',
        path: '/admin/reports'
        layoutTemplate: 'layout'
        waitOn: ->
            [
                Meteor.subscribe('toalRegisterdChurch')
                Meteor.subscribe('toalRegisterdUser')
                Meteor.subscribe('TitheTotalsForAdmin')
                Meteor.subscribe('adminReportPub')
            ]
        onBeforeAction: ->
            if Roles.userIsInRole(Meteor.user(), 'superadmin') or Roles.userIsInRole(Meteor.userId(), 'admin')
                @next()
            else
                @redirect '/dashboard'


    @route 'userGifts',
        path: '/user/gifts/:id'
        layoutTemplate: 'layout'
        onBeforeAction: (pause) ->
            loggedInUser = Meteor.user()
            if !loggedInUser
                @render '/signin'
            else
                @next()
            return
        waitOn: ->
            Meteor.subscribe 'userReportPub', @params.id


    @route 'auto_mail',
        path: '/admin/auto_mail'
        layoutTemplate: 'layout'
        waitOn: ->
            [ Meteor.subscribe('adminEmailList') ]
        data: ->
            users = Meteor.users.find('roles': 'user').fetch()
            org = Meteor.users.find('roles': 'church').fetch()
            userEmailList = []
            orgEmailList = []
            if users
                users.forEach (d, i) ->
                    userEmailList.push d.emails[0].address
                    return
            if org
                org.forEach (d, i) ->
                    orgEmailList.push d.emails[0].address
                    return
            templateData =
                userEmailList: userEmailList
                orgEmailList: orgEmailList
            templateData



Router.route 'admin/users', ->
    @render 'admin_users'
        # onBeforeAction: ->
        #     if Roles.userIsInRole(Meteor.user(), 'superadmin') or Roles.userIsInRole(Meteor.userId(), 'admin')
        #         @next()
        #     else
        #         @redirect '/dashboard'
        #     return



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




Router.map ->
    # @route 'searchBlank',
    #   path: '/search/'
    #   layoutTemplate: 'layout'
    # @route 'search',
    #   path: '/search/:id'
    #   layoutTemplate: 'layout'
    #   waitOn: ->
    #     if @params.id == 'name'
    #       [
    #         Meteor.subscribe('churchNameSearch', Session.get('nameSearch'))
    #         Meteor.subscribe('churchNameCampaigns', Session.get('nameSearch'))
    #       ]
    #     else
    #       [
    #         Meteor.subscribe('churchSearch', @params.id)
    #         Meteor.subscribe('churchCampaigns', @params.id)
    #       ]
    #   data: ->
    #     churches = Meteor.users.find(roles: 'church')
    #     templateData =
    #       churches: Meteor.users.find(roles: 'church')
    #       code: @params.id
    #       campaigns: ChurchCodes.find(custom: true)
    #     if churches.count() <= 0
    #       templateData.noneFound = true
    #     templateData
    # @route 'getchurches',
    #   path: '/getchurches'
    #   layoutTemplate: 'layout'
    #   waitOn: ->
    #     [ Meteor.subscribe('getAllChurches') ]
    #   data: ->
    #     churches = Meteor.users.find(roles: 'church')
    #     templateData = churches: Meteor.users.find(roles: 'church')
    #     if churches.count() <= 0
    #       templateData.noneFound = true
    #     templateData
    # @route 'getcampaigns',
    #   path: '/getcampaigns'
    #   layoutTemplate: 'layout'
    #   waitOn: ->
    #     [ Meteor.subscribe('getAllCampaigns') ]
    #   data: ->
    #     churches = Meteor.users.find(roles: 'church')
    #     templateData =
    #       campaigns: ChurchCodes.find(custom: true)
    #       churches: Meteor.users.find(roles: 'church')
    #     if churches.count() <= 0
    #       templateData.noneFound = true
    #     templateData

    @route 'searchByName',
        path: '/search-by-name'
        layoutTemplate: 'layout'
    @route 'give',
        path: '/give/:id'
        layoutTemplate: 'layout'
        waitOn: ->
            [
                Meteor.subscribe('churchById', @params.id)
                Meteor.subscribe('myCards', Meteor.userId())
            ]
        data: ->
            cards = MyCards.find(user: Meteor.userId())
            userResult = Meteor.users.findOne(_id: @params.id)
            codeResult = ChurchCodes.findOne(_id: @params.id)
            churchObj = undefined
            churchID = undefined
            titleVal = ''
            subtitleVal = ''
            widthClass = ''
            infoWidthClass = ''
            contentClass = ''
            if !userResult
                if codeResult
                    churchID = codeResult.church
                    titleVal = codeResult.campaign
                    churchObj = Meteor.users.findOne(_id: churchID)
                    subtitleVal = churchObj.profile.churchName
                    Session.set 'givingCode', codeResult._id
                    widthClass = 'col-xs-12'
                    infoWidthClass = 'col-xs-12'
                    contentClass = ''
            else
                churchObj = userResult
                subtitleVal = churchObj.profile.churchName
                churchID = @params.id
                widthClass = 'col-md-8 col-xs-12'
                infoWidthClass = 'col-md-4 col-xs-12'
                contentClass = 'content animate-panel'
            templateData =
                church: churchObj
                cid: churchID
                title: titleVal
                subtitle: subtitleVal
                mycards: cards
                cardCount: cards.count()
                widthClass: widthClass
                infoWidthClass: infoWidthClass
                contentClass: contentClass
            templateData
    @route 'thanks',
        path: '/thanks/:id'
        layoutTemplate: 'layout'
        waitOn: ->
            [ Meteor.subscribe('TitheDetails', @params.id) ]
        data: ->
            templateData = tithe: Tithes.findOne(@params.id)
            templateData