ROOT_URL = 'https://joyful-giver.com'
#var ROOT_URL = 'http://localhost:3000/';
Accounts.onCreateUser (options, user) ->
  user.profile = if options.profile then options.profile else {}
  service = undefined
  if user.services != null
    service = _.keys(user.services)[0]
  email = user.services[service].email
  oldUser = undefined
  if email
    oldUser = Meteor.users.findOne('emails.address': email)
  if oldUser
    if oldUser.services then oldUser.services else {}
    if service == 'google' or service == 'facebook'
      oldUser.services[service] = user.services[service]
      Meteor.users.remove oldUser._id
      user = oldUser
  else
    if service == 'google' or service == 'facebook'
      if user.services[service].email
        user.emails = [ {
          address: user.services[service].email
          verified: true
        } ]
      else
        throw new (Meteor.Error)(500, '#{service} account has no email attached')
    user.profile.name = user.services[service].name
    user.profile = options.profile
    # if(service == "google" || service == "facebook")
    # throw new Meteor.Error(500, "Please sign up first then try to login with "+ JSON.stringify(options))
  # if(user.services.facebook){
  #     user.emails= [{address: user.services.facebook.email, verified:true}];
  #     user.profile = options.profile;
  #     user.profile.name = user.services.facebook.name;
  # }
  # if(user.services.google){
  #     user.emails= [{address: user.services.google.email, verified:true}];
  #     user.profile = options.profile;
  #     user.profile.name = user.services.google.name;
  # }
  user.profile.isActive = true
  user

Meteor.startup ->
  BrowserPolicy.framing.allowAll()
  BrowserPolicy.content.allowSameOriginForAll()
  BrowserPolicy.content.allowFontDataUrl()
  #BrowserPolicy.content.allowDataUrlForAll();
  BrowserPolicy.content.allowInlineScripts()
  BrowserPolicy.content.allowScriptOrigin 'https://cdn.jsdelivr.net'
  # BrowserPolicy.content.allowOriginForAll('https://*.facebook.net/*');
  BrowserPolicy.content.allowStyleOrigin 'https://cdn.jsdelivr.net'
  BrowserPolicy.content.allowEval()
  BrowserPolicy.content.allowInlineStyles()
  BrowserPolicy.content.allowOriginForAll 'https://joyful-giver-cloud.s3-us-west-2.amazonaws.com/*'
  BrowserPolicy.content.allowOriginForAll '*.google.com/*'
  BrowserPolicy.content.allowOriginForAll 'https://*.facebook.net/'
  BrowserPolicy.framing.allowAll 'https://www.facebook.com/'
  BrowserPolicy.content.allowFrameOrigin 'https://*.facebook.com/'
  BrowserPolicy.content.allowSameOriginForAll 'https://www.facebook.com'
  BrowserPolicy.content.allowOriginForAll '*.amazonaws.com'
  BrowserPolicy.content.allowOriginForAll 'fonts.googleapis.com'
  BrowserPolicy.content.allowOriginForAll 'https://ajax.googleapis.com'
  BrowserPolicy.content.allowOriginForAll '*.googleapis.com'
  BrowserPolicy.content.allowOriginForAll '*.gstatic.com'
  BrowserPolicy.content.allowOriginForAll 'https://embed.tawk.to'
  BrowserPolicy.content.allowOriginForAll 'https://*.tawk.to'
  BrowserPolicy.content.allowOriginForAll 'https://static-v.tawk.to/*'
  BrowserPolicy.content.allowOriginForAll 'https://va.tawk.to/*'
  BrowserPolicy.content.allowOriginForAll 'https://va.tawk.to/log-performance/v3'
  BrowserPolicy.content.allowOriginForAll '*.stripe.com'
  BrowserPolicy.content.allowOriginForAll 'https://m.stripe.network/*'
  BrowserPolicy.content.allowOriginForAll 'http://bitrix.info/ba.js'
  # BrowserPolicy.content.allowOriginForAll( 'https://cdn.bitrix24.com' );
  # BrowserPolicy.content.allowOriginForAll( 'https://joyfulgivercom.bitrix24.com/' );
  # BrowserPolicy.content.allowOriginForAll( 'http://seal-dallas.bbb.org/*' );
  # BrowserPolicy.content.allowOriginForAll( 'https://seal-dallas.bbb.org/*' );
  BrowserPolicy.content.allowImageOrigin 'https://seal-dallas.bbb.org'
  Meteor.users._ensureIndex 'profile.churchName': 'text'
  environment = undefined
  settings = undefined
  SERVER_SETTINGS = undefined
  environment = process.env.NODE_ENV
  process.env.MAIL_URL = 'smtp://info@joyful-giver.com:Joyful83!@smtp.gmail.com:587/'
  #process.env.MAIL_URL="smtp://david@davidryanspeer.com:zimbatdrs2010@smtp.gmail.com:465";
  #process.env.MONGO_URL="mongodb://jgiver:joy20!5@apollo.modulusmongo.net:27017/iweZ5uni";
  #process.env.MONGO_OPLOG_URL="mongodb://jgiver:joy20!5@apollo.modulusmongo.net:27017/iweZ5uni";
  if Meteor.isProduction
    SyncedCron.start()
  #Meteor.absoluteUrl.defaultOptions.rootUrl = process.env.ROOT_URL;
  Meteor.absoluteUrl.defaultOptions.rootUrl = ROOT_URL
  process.env.ROOT_URL = ROOT_URL
  process.env.MOBILE_ROOT_URL = process.env.ROOT_URL
  process.env.MOBILE_DDP_URL = process.env.ROOT_URL
  # console.log process.env
  #console.log(__meteor_runtime_config__.ROOT_URL);
  Meteor.call 'checkCreateAdmin'
  #Meteor.users.update({"profile.isActive": {$exists:false}},{$set:{'profile.isActive':true}},{multi: true});
  #Meteor.users.update({"profile.isJGFeesApply": {$exists:false},'roles':'church'},{$set:{'profile.isJGFeesApply':true}},{multi: true});
  return
if process.env.NODE_ENV == 'development'
  SERVER_SETTINGS = Meteor.settings.development.private
if process.env.NODE_ENV == 'staging'
  SERVER_SETTINGS = Meteor.settings.staging.private
if process.env.NODE_ENV == 'production'
  SERVER_SETTINGS = Meteor.settings.production.private
Slingshot.createDirective 'myFileUploads', Slingshot.S3Storage,
  bucket: 'joyful-giver-cloud'
  AWSAccessKeyId: 'AKIAJGXCTOTXWDFL6J4Q'
  AWSSecretAccessKey: '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'
  region: 'us-west-2'
  acl: 'private'
  authorize: ->
    true
  key: (file) ->
    console.log file
    #Store file into a directory by the user's username.
    moment().format('X') + '-' + file.name
ServiceConfiguration.configurations.upsert { service: 'facebook' }, $set:
  appId: SERVER_SETTINGS.facebook.appId
  secret: SERVER_SETTINGS.facebook.secret
ServiceConfiguration.configurations.upsert { service: 'google' }, $set:
  clientId: SERVER_SETTINGS.google.clientId
  secret: SERVER_SETTINGS.google.secret
Meteor.methods
  'phone_updated': (phone) ->
    `var phone`
    TWIL = new Twilio(
      from: SERVER_SETTINGS.TWILIO.FROM
      sid: SERVER_SETTINGS.TWILIO.SID
      token: SERVER_SETTINGS.TWILIO.TOKEN)
    phone = phone
    TWIL.sendSMS
      to: '+' + phone
      body: 'Your Joyful-Giver phone number has been updated!'
    return
  'churchSearch': (query, options) ->
    options = options or {}
    regex = new RegExp(query)
    # The Roles package doesn't allow additional queries, so we're gonna do it by finding all matching users but only returning the ones who also have the Role "church".
    q =
      $or: [
        { 'profile.churchName':
          $regex: regex
          $options: 'i' }
        { 'profile.address.street':
          $regex: regex
          $options: 'i' }
        { 'profile.address.city':
          $regex: regex
          $options: 'i' }
      ]
      'profile.isActive': true
    # q = {"profile.churchName" : {$regex: regex, $options: "i"}};
    users = Meteor.users.find(q).fetch()
    users
  'churchGeoSearch': (lat, lng, distance, limit) ->
    distance == distance or 50000
    distance = Number(distance)
    console.log distance
    limit = limit or 50
    churches = Meteor.users.find(
      roles: 'church'
      'profile.loc': $near: $geometry:
        type: 'Point'
        coordinates: [
          lng
          lat
        ]).fetch()
    #console.log(churches)
    churches
  'PUBLIC_SETTINGS': ->
    if process.env.NODE_ENV == 'development'
      return Meteor.settings.development.public
    if process.env.NODE_ENV == 'staging'
      return Meteor.settings.staging.public
    if process.env.NODE_ENV == 'production'
      return Meteor.settings.production.public
    return
