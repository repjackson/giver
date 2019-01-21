Template.church_detail_public.helpers
    'mycards': ->
        #console.log('client side card helper')
        MyCards.find user: Meteor.userId()
    'cardCount': ->
        #console.log('client side card count helper')
        if Meteor.userId()
            cards = MyCards.find(user: Meteor.userId())
            cards.count()
        else
            0
    campaigns: ->
        campaignsList = ChurchCodes.find(church: Router.current().params._id).fetch()
        if campaignsList
            campaignsList
        else
            []
    'churchProfilePic': ->
        churchToFind = Meteor.users.find(_id: Router.current().params._id).fetch()
        if churchToFind[0]
            churchToFind[0].profile.profilePic
        else
            null
    'codeChurchName': ->
        churchToFind = Meteor.users.find(_id: Router.current().params._id).fetch()
        if churchToFind[0]
            churchToFind[0].profile.churchName
        else
            ''
    'codeCityName': ->
        churchToFind = Meteor.users.find(_id: Router.current().params._id).fetch()
        if churchToFind[0]
            churchToFind[0].profile.address.city
        else
            ''
    'codeStateName': ->
        churchToFind = Meteor.users.find(_id: Router.current().params._id).fetch()
        if churchToFind[0]
            churchToFind[0].profile.address.state
        else
            ''

    'campaignText': (param1) ->
        cleanText = ''
        if param1
            cleanText = param1.replace(/<\/?[^>]+(>|$)/g, '')
            cleanText = cleanText.replace(/&nbsp;/g, '')
        cleanText

    'churchImages': ->
        campaignsList = ChurchCodes.find(church: Router.current().params._id).fetch()
        images = []
        campaignsList.forEach (d, i) ->
            if d.customPage and d.customPage.header_image
                images.push d.customPage.header_image
        images

    'churchDetailMapOptions': ->
        # Make sure the maps API has loaded
        if GoogleMaps.loaded()
            # Map initialization options
            return {
                center: new (google.maps.LatLng)(@churchDet.profile.loc.coordinates[1], @churchDet.profile.loc.coordinates[0])
                draggable: false
                zoom: 15
                streetViewControl: true
            }


Template.body.onCreated ->
    # We can use the `ready` callback to interact with the map API once the map is ready.
    GoogleMaps.ready 'churchDetailMap', (map) ->
        # Add a marker to the map once it's ready
        marker = new (google.maps.Marker)(
            position: map.options.center
            map: map.instance)
        return
    #end of GoogleMaps.ready

Template.church_detail_public.onRendered ->
    marker = new (google.maps.Marker)(
        position: new (google.maps.LatLng)(@data.churchDet.profile.loc.coordinates[1], @data.churchDet.profile.loc.coordinates[0])
        map: GoogleMaps.maps.churchDetailMap.instance)
    $('.lazy').slick
        lazyLoad: 'ondemand'
        infinite: true
    churchToFind = Meteor.users.find(_id: Router.current().params._id).fetch()
    if churchToFind[0]
        if churchToFind[0].profile and churchToFind[0].profile.churchName
            Meta.setTitle churchToFind[0].profile.churchName + ' - Joyful Giver | #1 Online Fundraising and donation site.'
        else
            Meta.setTitle 'Joyful Giver | #1 Online Fundraising and donation site.'
        Meta.set 'og:title', churchToFind[0].profile.churchName + ' - Joyful Giver | #1 Online Fundraising and donation site.'
        Meta.set 'twitter:title', churchToFind[0].profile.churchName + ' - Joyful Giver | #1 Online Fundraising and donation site.'
        Meta.set 'description', 'Give ' + churchToFind[0].profile.churchName + 'Joyful Giver | #1 Online Fundraising and donation site.'
        Meta.set 'og:description', 'Give ' + churchToFind[0].profile.churchName + 'Joyful Giver | #1 Online Fundraising and donation site.'
        if churchToFind[0].profile and churchToFind[0].profile.profilePic
            Meta.set 'og:image', churchToFind[0].profile.profilePic
            Meta.set 'twitter:image', churchToFind[0].profile.profilePic
        else
            Meta.set 'og:image', '/icons/Logo_sm_100.png'
            Meta.set 'twitter:image', '/icons/Logo_sm_100.png'
        Meta.dict.keyDeps.title.changed()