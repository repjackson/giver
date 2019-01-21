allMapMarkers = []

Template.registerHelper 'dev', () -> Meteor.isDevelopment

Template.registerHelper 'is_church', () ->
  Roles.userIsInRole(Meteor.userId(), 'church')

Template.registerHelper 'is_user', () ->
  Roles.userIsInRole(Meteor.userId(), 'user')

Template.registerHelper 'is_admin', () ->
  Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'doc', () ->
  Docs.findOne Router.current().params.id


Meteor.startup ->
  Meteor.call 'PUBLIC_SETTINGS', (error, result) ->
    Session.set 'SETTINGS', result
    Stripe.setPublishableKey result.stripePublishable
    mapsApiKey = result.mapsApiKey
    return
  Meteor.subscribe 'appSettings'
  Template.registerHelper 'JOYsettings', ->
    AppSettings.findOne()
  GoogleMaps.load
    v: '3'
    key: 'AIzaSyA44_Aq1-OkLvnmDKnTlfDBCRn-aOsSnKU'
  Slingshot.fileRestrictions 'myFileUploads',
    allowedFileTypes: [
      'image/png'
      'image/jpeg'
      'image/gif'
    ]
    maxSize: 2 * 1024 * 1024

  iosgivepageload = (giveid) ->
    #console.log('entered iospageload... giveid=> ', giveid);
    if Meteor.isCordova
      devicePlatform = device.platform
      #console.log(devicePlatform);
      if devicePlatform == 'iOS'
        #window.open(encodeURI("http://localhost:3000/give/"+giveid), '_system'); //FIXME change to localhost:3000 to joyful-giver.com
        window.open encodeURI('https://joyful-giver.com/give/' + giveid), '_system'
      else
        Router.go '/give/' + giveid
    else
      #console.log('Loading give - ', giveid );
      Router.go '/give/' + giveid
    return

  iosorgpageload = (giveid) ->
    Router.go '/churchDetail/' + giveid
    return

  # ioscamppageload = function(giveid){
  #     console.log('entered ioscamppageload...');
  #     if(Meteor.isCordova){
  #         var devicePlatform = device.platform;
  #         console.log(devicePlatform);
  #         if(devicePlatform=="iOS"){
  #            //window.open(encodeURI("http://localhost:3000/"+giveid), '_system'); //FIXME change to localhost:3000 to joyful-giver.com
  #            window.open(encodeURI("https://joyful-giver.com/"+giveid), '_system');
  #         }else{
  #            Router.go('/'+giveid)
  #         }
  #     }else{
  #         //console.log('not iOS');
  #         Router.go('/'+giveid)
  #     }
  #
  # }
  Meta.config options:
    title: 'Joyful Giver | #1 Online Fundraising and donation site.'
    suffix: ''
  Meta.set 'fragment', '!'
  Meta.set [
    {
      name: 'property'
      property: 'og:description'
      content: 'Joyful-Giver: The most trusted online fundraising and giving platform. Start a successful campaign on the site.'
    }
    {
      name: 'name'
      property: 'description'
      content: 'Joyful-Giver: The most trusted online fundraising and giving platform. Start a successful campaign on the site.'
    }
    {
      name: 'property'
      property: 'og:title'
      content: 'Joyful Giver | #1 Online Fundraising and donation site.'
    }
    {
      name: 'property'
      property: 'og:type'
      content: 'website'
    }
    {
      name: 'property'
      property: 'og:image'
      content: '/icons/Logo_sm_100.png'
    }
    {
      name: 'name'
      property: 'twitter:card'
      content: 'summary'
    }
    {
      name: 'name'
      property: 'twitter:title'
      content: 'Joyful Giver | #1 Online Fundraising and donation site.'
    }
    {
      name: 'name'
      property: 'twitter:description'
      content: 'Joyful-Giver: The most trusted online fundraising and giving platform. Start a successful campaign on the site.'
    }
    {
      name: 'name'
      property: 'twitter:image'
      content: '/icons/Logo_sm_100.png'
    }
  ]