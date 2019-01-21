Template.customLanding.helpers
  'code': ->
    #console.log('client side code helper')
    ChurchCodes.findOne code: @code.toUpperCase()
  'currentpageURL': ->
    window.location.href
  'church': ->
    #console.log('client side church helper')
    code = ChurchCodes.findOne(code: @code.toUpperCase())
    Meteor.subscribe 'churchById', code.church
    Meteor.users.findOne _id: code.church
  'cid': ->
    #console.log('client side cid helper')
    #console.log('cid '+this.code)
    @code.toUpperCase()
  'widthClass': ->
    'col-xs-12'
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
  'titheTotalGive': ->
    tithesList = Tithes.find(churchCODE: @code.toUpperCase()).fetch()
    totalGive = 0
    tithesList.forEach (d, i) ->
      totalGive += d.amount
      return
    if totalGive
      totalGive = totalGive / 100
    parseInt totalGive
  totalGiver: ->
    tithesList = Tithes.find({ churchCODE: @code.toUpperCase() }, sort: 'date': -1).fetch()
    userArray = []
    tithesList.forEach (d, i) ->
      userJson = {}
      if d.userID
        user = Meteor.users.findOne(_id: d.userID)
        userJson['name'] = user.profile.name
        userJson['profilePic'] = if user.profile.profilePic then user.profile.profilePic else '/brand/android_hdpi.png'
        userJson['redirectionLink'] = '/user/profile/' + d.userID
      else
        userJson['name'] = 'Anonymous'
        userJson['profilePic'] = '/brand/android_hdpi.png'
        userJson['redirectionLink'] = '#'
      userJson['giveAmount'] = d.amount / 100
      userJson['date'] = moment(d.date, 'X').fromNow()
      userArray.push userJson
      return
    userArray
Template.customLanding.onRendered ->
  churchToFind = ChurchCodes.findOne(code: @data.code.toUpperCase())
  if churchToFind
    if churchToFind.campaign
      Meta.setTitle churchToFind.campaign + ' - Joyful Giver | #1 Online Fundraising and donation site.'
    else
      Meta.setTitle 'Joyful Giver | #1 Online Fundraising and donation site.'
    Meta.set 'og:title', churchToFind.campaign + ' - Joyful Giver | #1 Online Fundraising and donation site.'
    Meta.set 'twitter:title', churchToFind.campaign + ' - Joyful Giver | #1 Online Fundraising and donation site.'
    Meta.set 'description', 'Give ' + churchToFind.code + 'Joyful Giver | #1 Online Fundraising and donation site.'
    Meta.set 'og:description', 'Give ' + churchToFind.code + 'Joyful Giver | #1 Online Fundraising and donation site.'
    if churchToFind.customPage and churchToFind.customPage.header_image
      Meta.set 'og:image', churchToFind.customPage.header_image
      Meta.set 'twitter:image', churchToFind.customPage.header_image
    else
      Meta.set 'og:image', '/icons/Logo_sm_100.png'
      Meta.set 'twitter:image', '/icons/Logo_sm_100.png'
    Meta.dict.keyDeps.title.changed()
    try
      FB.XFBML.parse()
    catch e