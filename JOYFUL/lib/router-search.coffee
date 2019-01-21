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