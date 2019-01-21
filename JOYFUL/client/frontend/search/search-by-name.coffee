churchNameSearchSub = null
churchNameCampaignsSub = null
allChurchSub = null

stopAnimation = (marker, infowin, map) ->
  setTimeout (->
    marker.setAnimation null
    infowin.open map, marker
    return
  ), 750
  return

stopAnimationNoInfo = (marker) ->
  setTimeout (->
    marker.setAnimation null
    return
  ), 750
  return

Template.searchByName.onRendered ->
  Session.set 'code', ''
  Session.set 'name', ''
  Session.set 'churchesList', []
  Session.set 'campaignsList', []
  Tracker.autorun ->

    ###
          if (churchNameSearchSub != null && (Session.get('name') || Session.get('code')))
          {
            churchNameSearchSub.stop();
          }
          if(churchNameCampaignsSub != null && (Session.get('name') || Session.get('code')))
          {
            churchNameCampaignsSub.stop();
          }
          if(allChurchSub != null && (Session.get('name') || Session.get('code')))
          {
            allChurchSub.stop();
          }
    ###

    #if(Session.get('name')){
    churchNameSearchSub = Meteor.subscribe('churchNameSearch', Session.get('name'), ->
      Session.set 'churchesList', Meteor.users.find(roles: 'church').fetch()
      #      Session.set('code','');
      #      Session.set('name','');
      return
    )
    churchNameCampaignsSub = Meteor.subscribe('churchNameCampaigns', Session.get('code'), ->
      Session.set 'campaignsList', ChurchCodes.find().fetch()
      #Session.set('code','');
      #Session.set('name','');
      return
    )
    #}else if(Session.get('code')){
    #     churchNameCampaignsSub =  Meteor.subscribe('churchCampaigns',Session.get('code'),function(){
    #       Session.set('campaignsList',ChurchCodes.find({custom: true}).fetch());
    #Session.set('code','');
    #Session.set('name','');
    #     });
    #        churchNameSearchSub = Meteor.subscribe('churchSearch',Session.get('code'),function(){
    #        Session.set('churchesList', Meteor.users.find({roles: 'church'}).fetch());
    #        Session.set('code','');
    #Session.set('name','');
    #      });
    #}
    return
  return
Template.searchByName.events
  'click #find': ->
    Session.set 'code', ''
    Session.set 'name', ''
    churchNameSearchSub.stop()
    churchNameCampaignsSub.stop()
    Session.set 'churchesList', []
    Session.set 'campaignsList', []
    name = $('#name').val()
    code = $('#name').val()
    if !name
      bootbox.alert 'Please enter name or code.'
      Session.set 'code', ''
      Session.set 'name', ''
    else
      Session.set 'name', name
      Session.set 'code', code
    return
  'click #allchurch': ->
    # Session.set('backPath','/search-by-name');
    # Router.go('/getchurches')
    allChurchSub = Meteor.subscribe('getAllChurches', ->
      Session.set 'churchesList', Meteor.users.find(roles: 'church').fetch()
      return
    )
    return
  'keydown input': (event) ->
    if event.keyCode == 13
      Session.set 'code', ''
      Session.set 'name', ''
      churchNameSearchSub.stop()
      churchNameCampaignsSub.stop()
      Session.set 'churchesList', []
      Session.set 'campaignsList', []
      name = $('#name').val()
      code = $('#name').val()
      if !name
        bootbox.alert 'Please enter name or code.'
        Session.set 'code', ''
        Session.set 'name', ''
      else
        Session.set 'name', name
        Session.set 'code', code


  'click .recenter': (event, template) ->
    console.log 'recenter'
    latLng = @profile.loc.coordinates
    map = GoogleMaps.maps.churchMap.instance
    orgId = @_id
    currID = ''
    n = 0
    while n < allMapMarkers.length
      currID = allMapMarkers[n].id
      mymarker = allMapMarkers[n].marker
      infowin = allMapMarkers[n].iw
      if currID == @_id
        map.setCenter mymarker.position
        mymarker.setAnimation google.maps.Animation.BOUNCE
        stopAnimation mymarker, infowin, map
      else
        infowin.close map, mymarker
      n++


  'click .coderecenter': (event, template) ->
    map = GoogleMaps.maps.churchMap.instance
    currID = ''
    n = 0
    while n < allMapMarkers.length
      currID = allMapMarkers[n].id
      mymarker = allMapMarkers[n].marker
      infowin = allMapMarkers[n].iw
      if currID == @church
        mymarker.setAnimation google.maps.Animation.BOUNCE
        stopAnimationNoInfo mymarker
        map.setCenter mymarker.position
      else
        infowin.close map, mymarker
      n++


  'click .give': (event, template) ->
    Session.set 'givingCode', @code
    iosgivepageload @_id


  'click .add': (event, template) ->
    code = event.currentTarget.id
    if code == 'name'
      code = null
    Meteor.call 'addMyChurches', @_id, code, (err, res) ->
      if err
        alert 'There was an error adding this church. Please try again.'
      else
        alert 'This organization has been added to your account.'

Template.searchByName.helpers
  churches: ->
    #console.log("WTF", Session.get('churchesList') );
    Session.get 'churchesList'
  campaigns: ->
    #console.log(this);
    #console.log("WTF2", Session.get('campaignsList') );
    Session.get 'campaignsList'
  'codeChurchName': ->
    churchToFind = Meteor.users.find(_id: @church).fetch()
    if churchToFind[0]
      churchToFind[0].profile.churchName
    else
      ''
  'codeCityName': ->
    churchToFind = Meteor.users.find(_id: @church).fetch()
    if churchToFind[0]
      churchToFind[0].profile.address.city
    else
      ''
  'codeStateName': ->
    churchToFind = Meteor.users.find(_id: @church).fetch()
    if churchToFind[0]
      churchToFind[0].profile.address.state
    else
      ''
  'churchProfilePic': ->
    churchToFind = Meteor.users.find(_id: @church).fetch()
    if churchToFind[0]
      pic = churchToFind[0].profile.profilePic
      retString = '<div style="height:125px; overflow:hidden;  background: #ffffff url(' + pic + ') no-repeat right top;"></div>'
      retString
    else
      null