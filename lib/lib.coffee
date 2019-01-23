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


addTithe = (result) ->
    id = Tithes.insert(
        status: result.status
        church: result.metadata.church
        churchCODE: result.metadata.givingCODE
        userID: result.metadata.user
        chargeID: result.id
        amount: result.amount
        date: moment().format('X')
        data: result
        plan: result.metadata.plan
        churchVerified: false)
    if result.metadata.plan != null
        TithePlanObj =
            status: 'active'
            churchCODE: result.metadata.churchCODE
            source: result.source.id
            firstChargeDate: moment().format('X')
            firstCharge: id
            lastChargeDate: moment().format('X')
            lastCharge: id
        Meteor.call 'updateTithePlanObj', result.metadata.plan, TithePlanObj
    id




Docs.before.insert (userId, doc)=>
    timestamp = Date.now()
    doc._timestamp = timestamp
    doc._timestamp_long = moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
    date = moment(timestamp).format('Do')
    weekdaynum = moment(timestamp).isoWeekday()
    weekday = moment().isoWeekday(weekdaynum).format('dddd')

    month = moment(timestamp).format('MMMM')
    year = moment(timestamp).format('YYYY')

    date_array = [weekday, month, date, year]
    if _
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
    # date_array = _.each(date_array, (el)-> console.log(typeof el))
    # console.log date_array
        doc.timestamp_tags = date_array

    doc.author_id = Meteor.userId()
    return


Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()
    is_author: -> Meteor.userId() is @author_id

    downvoters: ->
        Meteor.users.find
            _id: $in: @downvoter_ids
    upvoters: ->
        Meteor.users.find
            _id: $in: @upvoters_ids


Slingshot.fileRestrictions 'myFileUploads',
    allowedFileTypes: [
        'image/png'
        'image/jpeg'
        'image/gif'
    ]
    maxSize: 2 * 1024 * 1024