Future = Npm.require('fibers/future')
Meteor.methods
  'getGeoLoc': (data) ->
    findUsers2 = new Future
    usrID = data.user
    result = HTTP.get(data.link)
    console.log 'SERVER: ', result
    if result.data.status == 'OK'
      nlat = result.data.results[0].geometry.location.lat
      nlng = result.data.results[0].geometry.location.lng
      newLoc = [
        nlng
        nlat
      ]
      console.log 'SERVER: ', newLoc
      findUsers2.return newLoc
    else
      findUsers2.return false
    findUsers2.wait()
  'createChurchAccount': (options) ->
    address = encodeURIComponent(options.profile.address.street + ',' + options.profile.address.city + ',' + options.profile.address.state + ' ' + options.profile.address.zip)
    geoURL = 'https://maps.googleapis.com/maps/api/geocode/json?address=' + address + '&key=' + Meteor.settings.production.public.mapsApiKey
    # console.log(geoURL);
    result = HTTP.get(geoURL)
    options.profile.loc =
      'type': 'Point'
      'coordinates': [
        result.data.results[0].geometry.location.lng
        result.data.results[0].geometry.location.lat
      ]
    id = Accounts.createUser(options)
    # console.log(id);
    if id
      Roles.addUsersToRoles id, 'church'
    userInfo =
      email: options.email
      name: options.profile.churchName
    Meteor.call 'sendEmail', userInfo
    html = '<table>' + '<tr>' + '<th>ORG NAME : </th>' + '<td>' + options.profile.churchName + '</td>' + '</tr>' + '<tr>' + '<th>PERSON NAME : </th>' + '<td>' + options.profile.name + '</td>' + '</tr>' + '<tr>' + '<th>EMAIL Address : </th>' + '<td>' + options.email + '</td>' + '</tr>' + '<tr>' + '<th>PHONE NO : </th>' + '<td>' + options.profile.phone + '</td>' + '</tr>' + '<tr>' + '<th>DATE : </th>' + '<td>' + moment().format('MMM DD YYYY') + '</td>' + '</tr>' + '</table>'
    SSR.compileTemplate 'emailText', html
    emailObj =
      to: 'info@joyful-giver.com'
      subject: 'New organization registered'
    emailObj['html'] = SSR.render('emailText')
    emailObj['from'] = 'info@joyful-giver.com'
    Email.send emailObj
    text = 'Welcome to Joyful Giver, ' + options.profile.churchName + ' As a new partner, we are giving your organization a FREE 30-day trial! No processing fee for donations made within the next 30 days! ' + 'To take advantage of this, email us at info@joyful-giver.com or call 1-888-252-0635. Thank you for choosing Joyful Giver. '
    Meteor.call 'SMS_SEND', options.profile.phone, text
    return
  'process_SMS_registration': (phone, email, password) ->
    `var email`
    `var userEmail`
    processRegistration = new Future
    data = {}
    email = email.toLowerCase()
    #FIND LIKE USERS
    users = Meteor.users.find('profile.phone': phone)
    count = users.count()
    if count > 0
      i = 0
      used = []
      _.each users.fetch(), (userData) ->
        used[i] = userData.emails[0].address
        i++
        return
      data.error = true
      data.message = 'Phone Number Registered'
      data.bootbox = true
      data.continue = false
      data.login = false
      data.content = 'This phone number is already registered.<br><br><a href=\'sms://+18555784483\'>Text REMOVE</a> from the device to remove the number from the account.'
    #CHECK IF THE USERS PHONE BELONGS TO THE USER SIGNING UP / LOGGIN IN
    if data.error
      console.log email
      userEmail = Meteor.users.findOne(emails: $elemMatch: address: email)
      userPhone = Meteor.users.findOne('profile.phone': phone)
      console.log userEmail
      console.log userPhone
      if userEmail._id == userPhone._id
        console.log 'EMAILS MATCH'
        data.error = false
        if userEmail
          data.login = true
        else
          data.continue = true
      else
        console.log 'NO MATCH'
    if !data.error
      data.error = false
      userEmail = Meteor.users.findOne(emails: $elemMatch: address: email)
      if userEmail
        data.login = true
      else
        data.continue = true
    processRegistration.return data
    processRegistration.wait()
