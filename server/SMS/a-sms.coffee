#CHECK IF THE VALUE PASSED IS A NUMBER

isNumber = (n) ->
  !isNaN(parseFloat(n)) and isFinite(n)

#VALIDATE AN INTERNATIONAL PHONE NUMBER +1XXXXXXXXXX

isE164phone = (phone) ->
  regex = /^\+(?:[0-9] ?){6,14}[0-9]$/
  if regex.test(phone)
    true
  else
    false

#CHECK IF THE SMS DB ALREADY HAS A RECORD OF SELECTING CREDIT CARD AND RETURN THE SMS RECORD
#THIS IS VERY IMPORTANT FOR ROUTING CREDIT CARD SELECTION NUMBERS TO THE SELECTION PAGE
#OTHER WISE NUMBERS ARE PARSED AS AN AMOUNT TO CHARGE

SMS_GET_SELECT_STATUS = (data) ->
  user = Meteor.users.findOne('profile.phone': data.From)
  if user
    sms_record = SMS.findOne(
      user: user._id
      card_status: 'selecting'
      expires: $gte: moment().format('X'))
    if sms_record
      sms_record._id
    else
      false
  else
    false

# Configure the Twilio client
HTTP.publish { name: 'twilio' }, (data) ->
  console.log 'http hit'
  return
SMS = new (Meteor.Collection)('SMS')
# Add access points for `GET`, `POST`, `PUT`, `DELETE`
HTTP.publish { collection: SMS }, (data) ->
  query = @query
  #console.log("query = ", query);
  text = ''
  try
    text = query.Body.replace('$', '')
  catch err
    txt = query.Body
    if txt.search('$') != -1
      text = txt
    else
      text = txt.replace('$', '')
    console.log 'Failed to replace $, Error = ', err
    console.log 'Using this received val =', text
  #console.log(text);
  if isNumber(text) and parseInt(text) >= 3
    selectingcard = SMS_GET_SELECT_STATUS(query)
    if selectingcard
      Meteor.call 'SMS_SET_CARD', selectingcard, query
    else
      Meteor.call 'SMS_SET_AMOUNT', query
  else if isNumber(text) and parseInt(text) < 3 or isNumber(text) and parseInt(text) > 99
    if SMS_GET_SELECT_STATUS(query)
      Meteor.call 'SMS_SET_CARD', SMS_GET_SELECT_STATUS(query), query
    else
      Meteor.call 'SMS_SEND', query.From, 'You must select a dollar amount between $3 and $99. Enter an amount between 3-99.'
  else
    switch text.toUpperCase()
      when 'YES'
        Meteor.call 'SMS_CHARGE', query
      when 'NO'
        Meteor.call 'SMS_NO_CHARGE', query
      when 'REMOVE'
        Meteor.call 'SMS_REMOVE', query
      else
        Meteor.call 'SMS_FIND_USER', query
        break