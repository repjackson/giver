#RECURRING GIVING
@TithePlans = new (Meteor.Collection)('TithePlans')
@Tithes = new (Meteor.Collection)('Tithes')
@Notifications = new (Meteor.Collection)('Notifications')

@Docs = new (Meteor.Collection)('Docs')
@Tags = new (Meteor.Collection)('Tags')

@ChurchCodes = new (Meteor.Collection)('ChurchCodes')
@MyChurches = new (Meteor.Collection)('MyChurches')
@MyCards = new (Meteor.Collection)('MyCards')
@requestDemo = new (Meteor.Collection)('requestDemo')
#TO BE DEVELOPED AT A LATER DATE
#TaxDocs = new Meteor.Collection("TaxDocs");
#APP SETTINGS
@AppSettings = new (Meteor.Collection)('appsettings')
# Makes sure we can query churches by location
if Meteor.isServer
    Meteor.users._ensureIndex 'profile.loc': '2dsphere'

