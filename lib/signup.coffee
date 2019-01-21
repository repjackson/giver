Meteor.methods
  'createGiverAccount': (options, titheData) ->
    #console.log("options = ", options)
    uname = options.profile.name
    id = Accounts.createUser(options)
    if id
      Roles.addUsersToRoles id, 'user'
      Meteor.users.update id, $set: 'profile.name': uname
      if titheData
        Meteor.call 'updateTitheuserID', titheData.tithe, userID: id
        tithe = Tithes.findOne(titheData.tithe)
        source = tithe.data.source
        cardObj =
          cardid: source.id
          user: id
          exp_month: source.exp_month
          exp_year: source.exp_year
          last4: source.last4
        Meteor.call 'addMyCards', cardObj
      userInfo =
        email: options.email
        name: uname
      Meteor.call 'sendGiverEmail', userInfo
      Meteor.call 'STRIPE_create_customer', id, 'email'
      text = 'Welcome to Joyful Giver ' + uname + ', \n' + 'As a registered donor, you can save your favorite organizations, see past gifts/receipts, setup repeat giving, print reports and securely save card info for future use.'
      Meteor.call 'SMS_SEND', options.profile.phone, text
    return
  'savePhone2': (user, phone) ->
    `var data`
    users = Meteor.users.find('profile.phone': phone).count()
    if users > 0
      data =
        error: true
        message: 'A user is already using that phone number. Text REMOVE to ' + 13235242934 + ' to remove the number'
      data
    else
      Meteor.call 'savePhone2Method', user, {
        'profile.phone': phone
        'profile.phone_verified': false
      }, (err, success) ->
        if err
          console.log err
          console.log phone
        if success
          console.log phone
          if isE164phone(phone)
            Meteor.call 'phone_updated', phone
        return
      Meteor.call 'generateAuthCode', user, phone
      data =
        error: false
        message: 'We texted you a validation code. Enter the code below:'
      data
