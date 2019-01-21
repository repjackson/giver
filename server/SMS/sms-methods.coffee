#RESERVED METHODS

###  upper or lowercase
GIVE -> user or don't use? Leaning towards don't use
YES
NO
CANCEL
**** ->4 digit campaign identifier
###

Meteor.methods
  'SMS_SEND': (phone, text) ->
    #console.log(' ---> ' +' --- '+ SERVER_SETTINGS.TWILIO.FROM)
    #console.log(' ---> ' +' --- '+ SERVER_SETTINGS.TWILIO.SID)
    #console.log(' ---> ' +' --- '+ SERVER_SETTINGS.TWILIO.TOKEN)
    #console.log(' --- '+phone+' --- '+text)
    TWIL = new Twilio(
      from: SERVER_SETTINGS.TWILIO.FROM
      sid: SERVER_SETTINGS.TWILIO.SID
      token: SERVER_SETTINGS.TWILIO.TOKEN)
    console.log 'TWILIO object created!'
    TWIL.sendSMS {
      to: phone
      body: text
    }, (err, responseData) ->
      #this function is executed when a response is received from Twilio
      if !err
        console.log 'successfully send sms'
        # outputs "+14506667788"
        #console.log(responseData.from); // outputs "+14506667788"
        #console.log(responseData.body); // outputs "word to your mother."
      else
        console.log 'Error', err

  'SMS_CHARGE': (data) ->
    sms_record = SMS.findOne(
      phone: data.From
      amount_status: 'set'
      expires: $gte: moment().format('X'))
    #console.log("sms_record: ", sms_record)
    if sms_record
      #var church = Meteor.users.findOne(code.church)
      charge_data =
        church: sms_record.church
        amount: sms_record.amount
        cardid: sms_record.card
        code: sms_record.code
        user: sms_record.user
        phone: sms_record.phone
        sms_record: sms_record._id
      Meteor.call 'SMS_OneOffCharge', charge_data, (error, result) ->
        console.log error, result
        if result.error
          Meteor.call 'SMS_SEND', data.From, 'Charge Error: ' + result.error.message
        else
          if error
            Meteor.call 'SMS_SEND', data.From, 'Org. not ready for charges.'
          else
            if result.status == 'succeeded'
              Tithes.insert {
                status: result.status
                church: result.metadata.church
                churchCODE: result.metadata.churchCODE
                userID: result.metadata.user
                chargeID: result.id
                amount: result.amount
                date: moment().format('X')
                data: result
                method: 'sms'
                churchVerified: false
              }, ->
                Meteor.call 'SMS_SEND', data.From, 'Thank you for your donation. Log in to view your giving history: https://joyful-giver.com/signin'
                SMS.remove result.metadata.sms_record
      console.log 'sms_charge done!'
    else
      Meteor.call 'SMS_SEND', data.From, 'That give record could not be found. Your card will not be charged.'

  'SMS_NO_CHARGE': (data) ->
    sms_record = SMS.findOne(
      phone: data.From
      amount_status: 'set'
      expires: $gte: moment().format('X'))
    if sms_record
      #var church = Meteor.users.findOne(code.church)
      Meteor.call 'SMS_SEND', sms_record.phone, 'Your donation has been canceled. Your card will not be charged.', ->
        SMS.remove sms_record
    else
      Meteor.call 'SMS_SEND', data.From, 'That give record could not be found. Your card will not be charged.'

  'SMS_REMOVE': (data) ->
    SMS.remove phone: data.From
    Meteor.users.update { 'profile.phone': data.From }, $unset: 'profile.phone': null
    Meteor.call 'SMS_SEND', data.From, 'Text to Give has been removed. Sign-up or add your mobile number here: https://joyful-giver.com/SMS/reg?p=' + data.From

  'SMS_SET_AMOUNT': (data) ->
    `var giveText`
    sms_record = SMS.findOne(
      phone: data.From
      code_status: 'valid'
      expires: $gte: moment().format('X'))
    #console.log(sms_record)
    if sms_record
      if sms_record.campaign
        giveText = 'to ' + sms_record.churchName + ' for ' + sms_record.campaign + ' '
      else
        giveText = 'to ' + sms_record.churchName + ' '
      #var church = Meteor.users.findOne(code.church)
      Meteor.call 'SMS_SEND', sms_record.phone, 'Are you sure you want to give $' + data.Body + ' ' + giveText + '? Respond YES or NO', ->
        SMS.update sms_record, $set:
          amount: data.Body
          amount_status: 'set'
    else
      Meteor.call 'SMS_SEND', data.From, 'That give record could not be found.'

  'SMS_FIND_CARD': (sms_record, data) ->
    `var sms_record`
    `var giveText`
    sms_record = SMS.findOne(sms_record)
    user = Meteor.users.findOne(sms_record.user)
    cards = MyCards.find({ user: user._id }, sort:
      default: 1
      created: 1)
    if cards.count() > 1
      SMS.update sms_record, $set:
        card: cards.fetch()
        card_status: 'selecting'
      #do something for multiple cards
      text = ''
      count = 0
      _.each cards.fetch(), (cardData) ->
        count++
        text += count + ' for ' + cardData.last4 + ', '
        return
      Meteor.call 'SMS_SEND', data.From, 'Select a saved card: Respond with ' + text
    else if cards.count() == 1
      card = MyCards.findOne(user: user._id)
      SMS.update sms_record, $set:
        card: card.cardid
        card_status: 'selected'
      if sms_record.campaign
        giveText = 'for ' + sms_record.campaign + ' at ' + sms_record.churchName + ' '
      else
        giveText = 'for ' + sms_record.churchName + ' '
      Meteor.call 'SMS_SEND', data.From, 'Select an amount ' + giveText + 'in dollars: text a number 3-99'
    else
      #Meteor.call('SMS_SEND',data.From,"You don't have any cards saved. Add a card here: https://joyful-giver.com/sms/addcard/token")
      Meteor.call 'SMS_SEND', data.From, 'You don\'t have any cards saved. Please login & add a card: https://joyful-giver.com/myaccount'

  'SMS_SET_CARD': (sms_record, data) ->
    `var sms_record`
    sms_record = SMS.findOne(sms_record)
    user = Meteor.users.findOne(sms_record.user)
    cards = MyCards.find({ user: user._id }, sort:
      default: 1
      created: 1)
    count = 0
    _.each cards.fetch(), (cardData) ->
      `var giveText`
      count++
      if count == data.Body
        SMS.update sms_record._id, $set:
          card: cardData.cardid
          card_status: 'selected'
        sms_record2 = SMS.findOne(sms_record._id)
        if sms_record2.campaign
          giveText = 'for ' + sms_record2.campaign + ' at ' + sms_record2.churchName + ' '
        else
          giveText = 'for ' + sms_record2.churchName + ' '
        Meteor.call 'SMS_SEND', data.From, 'Card Selected! Enter an amount ' + giveText + 'in dollars: text a number 3-99'

  'SMS_FIND_CODE': (sms_record, data) ->
    texted_code = data.Body.toUpperCase()
    console.log 'valid code' + sms_record
    code = ChurchCodes.findOne('code': texted_code)
    if code
      church = Meteor.users.findOne(code.church)
      SMS.update sms_record, $set:
        phone: data.From
        church: church._id
        churchName: church.profile.churchName
        campaign: code.campaign
        code_status: 'valid'
      Meteor.call 'SMS_FIND_CARD', sms_record, data
    else
      Meteor.call 'SMS_SEND', data.From, 'That code does not exist. Text a valid give code.'
      SMS.remove sms_record

  'SMS_FIND_USER': (data) ->
    user = Meteor.users.findOne('profile.phone': data.From)
    if user
      #console.log(data)
      new_sms_record = SMS.insert(
        user: user._id
        phone: data.From
        code: data.Body
        query: data
        code_status: 'pending'
        expires: moment().add(20, 'minutes').format('X'))
      Meteor.call 'SMS_FIND_CODE', new_sms_record, data
    else
      Meteor.call 'SMS_SEND', data.From, 'Sign-up or add your mobile number here: https://joyful-giver.com/SMS/reg?p=' + data.From + '&c=' + data.Body

  'savePhone2Method': (user, obj) ->
    Meteor.users.update user, $set: obj
