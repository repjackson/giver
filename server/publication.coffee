Meteor.publish null, ->
    #var userFields = {
    #    'profile.stripe': 0,
    #    services: 0
    #}
    #console.log(this.userId)
    #if(this.userId){
    #    return Meteor.users.find(this.userId,{fields: userFields});
    #}else{
    #    return null
    # }
    return
Meteor.publish 'appSettings', ->
    count = AppSettings.find().count()
    if count == 0
        AppSettings.insert {}
    if count > 1
        AppSettings.remove {}
        AppSettings.insert {}
    AppSettings.find()

Meteor.publish 'myPlans', (id) ->
    TithePlans.find userID: id

Meteor.publish 'myCards', (user) ->
    #console.log('mycards called')
    MyCards.find user: user

Meteor.publish 'churchPlans', (id) ->
    TithePlans.find church: id


Meteor.publish 'onePlan', (id) ->
    TithePlans.find id

Meteor.publish 'planCharges', (id) ->
    Tithes.find plan: id

Meteor.publish 'churchSearch', (code) ->
    upperCode = code.toUpperCase()
    church = ChurchCodes.findOne(code: upperCode)
    if church
        churches = Meteor.users.find(
            '_id': church.church
            roles: 'church')
        churches
    else
        Meteor.users.find
            '_id': 'RETURN-A-BLANK-SET'
            roles: 'church'
#
# Meteor.publish('churchCampaigns',  (code){
#     var upperCode = code.toUpperCase();
# //console.log(ChurchCodes.find({code: upperCode,custom: true}).fetch()  );
# //return ChurchCodes.find({code: upperCode});
#     return ChurchCodes.find({code: upperCode,custom: true});
# });

Meteor.publish 'churchNameSearch', (name) ->
    `var options`
    `var f`
    `var result`
    allChurches = Meteor.users.find(
        roles: 'church'
        'profile.isActive': true).fetch()
    options =
        keys: [
            'profile.churchName'
            'profile.address.city'
            'profile.address.state'
        ]
        minMatchCharLength: 4
        id: '_id'
    f = new Fuse(allChurches, options)
    result = f.search(name)
    results = Meteor.users.find(_id: $in: result)
    #console.log(f);
    #console.log(results.count());
    if results.count() == 0
        allChurchCodes = ChurchCodes.find().fetch()
        options =
            keys: [
                'code'
                'campaign'
            ]
            minMatchCharLength: 5
            id: '_id'
        f = new Fuse(allChurchCodes, options)
        result = f.search(name)
        foundChurch = ChurchCodes.find(_id: $in: result).fetch()
        churchArray = []
        foundChurch.forEach (block) ->
            churchArray.push block.church
            return
        retVal = Meteor.users.find(
            roles: 'church'
            _id: $in: churchArray)
        retVal
    else
        results
#
# Meteor.publish('getAllChurches', function (){
#     return Meteor.users.find({roles: 'church'});
# });
#
# Meteor.publish('getAllCampaigns', function (){
#     return ChurchCodes.find({custom: true});
# });

Meteor.publish 'churchNameCampaigns', (name) ->
    allChurchCodes = ChurchCodes.find().fetch()
    options =
        keys: [
            'code'
            'campaign'
        ]
        minMatchCharLength: 5
        shouldSort: true
        tokenize: true
        threshold: 0.2
        id: '_id'
    f = new Fuse(allChurchCodes, options)
    result = f.search(name)
    #console.log("RESULT >>> ", result);
    #console.log("RESULT2 >>> ", ChurchCodes.find({_id: {$in: result}}) );
    ChurchCodes.find _id: $in: result

Meteor.publish 'churchById', (id) ->
    Meteor.users.find { _id: id }, fields:
        'profile.churchName': 1
        'profile.address': 1
        'profile.phone': 1
        'profile.website': 1
        'profile.profilePic': 1
        'emails.address': 1
#
# Meteor.publish('TitheChurch', function (id){
#     var tithe = Tithes.findOne(id)
#     return Meteor.users.find({roles: 'church', '_id': tithe.church},{fields: {profile: 1, roles: 1}})
# });

Meteor.publish 'TitheTotals', (church, start, end) ->
    Tithes.find {
        church: church
        date:
            $lte: end
            $gte: start
    }, fields:
        amount: 1
        date: 1

Meteor.publish 'UserTitheTotals', (user, start, end) ->
    Tithes.find {
        userID: user
        date:
            $lte: end
            $gte: start
    }, fields:
        amount: 1
        date: 1

Meteor.publish 'TitheDetails', (id) ->
    tithe = Tithes.findOne(id)
    [
        Meteor.users.find({ $or: [
            {
                roles: 'church'
                '_id': tithe.church
            }
            {
                roles: 'user'
                '_id': tithe.userID
            }
        ] }, fields:
            'profile.stripe': 0
            services: 0)
        Tithes.find(id)
    ]

Meteor.publish 'ChurchCodes', (id) ->
    ChurchCodes.find church: id

Meteor.publish 'oneCode', (code) ->
    #console.log('code called')
    [
        ChurchCodes.find(code: code)
        Tithes.find({ churchCODE: code }, fields:
            churchCODE: 1
            amount: 1
            date: 1
            userID: 1)
    ]

Meteor.publish 'oneChurchByCode', (code) ->
    #console.log('church by code called')
    churchDetail = ChurchCodes.find(code: code)
    allThithes = Tithes.find(churchCODE: code).fetch()
    userId = []
    allThithes.forEach (d, i) ->
        if d.userID
            userId.push d.userID
        return
    userId.push churchDetail.church
    Meteor.users.find { _id: $in: userId }, fields:
        'profile.churchName': 1
        'profile.address': 1
        'profile.name': 1
        'profile.profilePic': 1
#
# Meteor.publish('oneTithe', function (id){
#     return Tithes.find(id)
# });
# Meteor.publish('currentTithe', function (){
#     return Tithes.find()
# });
Meteor.publish 'myTithes', (user) ->
    Tithes.find userID: user
Meteor.publish 'churchTithes', (user) ->
    Tithes.find church: user
# Meteor.publish('myChurchesOld', function (user){
#     var tithes = Tithes.find({userID: user},{fields: {church: 1}}).fetch();
#     var distinctChurches = _.uniq(tithes, false, function(d) {return d.church});
#     var churchIDs = _.pluck(distinctChurches, 'church');
#     return Meteor.users.find({_id: {$in: churchIDs}},{fields: {profile: 1, roles: 1}})
# })
Meteor.publish 'myChurches', (user) ->
    churches = MyChurches.find({ user: user }, fields: church: 1).fetch()
    distinctChurches = _.uniq(churches, false, (d) ->
        d.church
    )
    churchIDs = _.pluck(distinctChurches, 'church')
    Meteor.users.find { _id: $in: churchIDs }, fields:
        profile: 1
        roles: 1

Meteor.publish 'myChurchData', (user) ->
    MyChurches.find user: user

Meteor.publish 'admin_churches', ->
    Meteor.users.find roles: 'church'

Meteor.publish 'admin_users', ->
    Meteor.users.find roles: 'user'

Meteor.publish 'ChurchReportPub', ->
    tithes = Tithes.find(church: @userId)
    giverArray = []
    tithes.fetch().forEach (d, i) ->
        if giverArray.indexOf(d.userID) == -1
            giverArray.push d.userID
        return
    giverList = Meteor.users.find({ _id: $in: giverArray }, fields:
        'profile.firstname': 1
        'profile.lastname': 1
        'profile.name': 1)
    churchCodes = ChurchCodes.find(church: @userId)
    [
        tithes
        giverList
        churchCodes
    ]

Meteor.publish 'userReportPub', (userId) ->
    tithes = Tithes.find(userID: if userId then userId else @userId)
    churchArray = []
    tithes.fetch().forEach (d, i) ->
        if churchArray.indexOf(d.church) == -1
            churchArray.push d.church
        return
    churchList = Meteor.users.find({ _id: $in: churchArray }, fields:
        'profile.firstname': 1
        'profile.lastname': 1
        'profile.name': 1
        'profile.churchName': 1)
    # var churchCodes = ChurchCodes.find({church: this.userId});
    [
        tithes
        churchList
    ]

Meteor.publish 'dailyTithesReport', ->
    tithes = Tithes.find(church: @userId)
    tithes

Meteor.publish 'church_detail_public', (id) ->
    churchDet = Meteor.users.find(_id: id)
    churchCampaign = ChurchCodes.find(church: id)
    [
        churchDet
        churchCampaign
    ]

Meteor.publish 'demoRequestList', ->
    requestDemo.find 'status': '$exists': false

Meteor.publish 'userById', (id) ->
    Meteor.users.find { _id: id }, fields: 'profile.name': 1

Meteor.publish 'TitheTotalsForAdmin', ->
    Tithes.find {}, fields:
        amount: 1
        date: 1

Meteor.publish 'toalRegisterdUser', ->
    Counts.publish this, 'registerdUser', Meteor.users.find(roles: 'user')


Meteor.publish 'toalRegisterdChurch', ->
    Counts.publish this, 'registerdChurch', Meteor.users.find(roles: 'church')


Meteor.publish 'adminReportPub', ->
    tithes = Tithes.find({})
    giverArray = []
    tithes.fetch().forEach (d, i) ->
        if giverArray.indexOf(d.userID) == -1
            giverArray.push d.userID
        if giverArray.indexOf(d.church) == -1
            giverArray.push d.church
        return
    giverList = Meteor.users.find({ _id: $in: giverArray }, fields:
        'profile.firstname': 1
        'profile.lastname': 1
        'profile.name': 1
        'profile.churchName': 1
        'roles': 1)
    churchCodes = ChurchCodes.find({})
    [
        tithes
        giverList
        churchCodes
    ]

Meteor.publish 'adminEmailList', ->
    Meteor.users.find {}, fields:
        'emails.address': 1
        'roles': 1

Meteor.publish 'userProfilePub', (userId) ->
    tithes = Tithes.find({ userID: userId }, fields:
        'church': 1
        'churchCODE': 1
        'amount': 1
        'date': 1)
    churchCodeArray = []
    churchArray = []
    tithes.fetch().forEach (d, i) ->
        if d.churchCODE and d.churchCODE != null and churchCodeArray.indexOf(d.churchCODE) == -1
            churchCodeArray.push d.churchCODE
        else
            churchArray.push d.church
        return
    churchArray.push userId
    churchCodeDet = ChurchCodes.find(code: $in: churchCodeArray)
    userDet = Meteor.users.find({ _id: $in: churchArray }, fields:
        'profile.firstname': 1
        'profile.lastname': 1
        'profile.name': 1
        'profile.profilePic': 1
        'profile.churchName': 1)
    [
        tithes
        userDet
        churchCodeDet
    ]




Meteor.publish 'doc', (doc_id)->
    Docs.find doc_id

Meteor.publish 'children', (doc_id)->
    Docs.find
        parent_id: doc_id

