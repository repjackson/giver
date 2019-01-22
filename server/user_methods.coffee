Meteor.methods
    'RemoveMyChurch': (user, church) ->
        console.log user, church
        MyChurches.remove
            user: user
            church: church

    'generateAuthCode': (user, phone) ->
        code = ('0000' + (Math.random() * 36 ** 4 << 0).toString(36)).slice(-4)
        upperCode = code.toUpperCase()
        Meteor.users.update user, { $set: 'profile.phone_auth': upperCode }, ->
            Meteor.call 'SMS_SEND', phone, 'Phone Validation Code: ' + upperCode

    'requestForDemo': (data) ->
        #   var fields = {
        #   "TITLE": data.firstName + ' ' +data.lastName,
        #   "NAME": data.firstName,
        #   "SECOND_NAME": data.lastName,
        #   "EMAIL_WORK": data.emailId,
        #   "PHONE_WORK": data.phoneNo,
        #   "UF_CRM_1516113493": data.date,
        #   "ASSIGNED_BY_ID":"28"
        # }
        #       HTTP.call( 'POST', 'https://joyfulgivercom.bitrix24.com/rest/1/785zo4yv2tw9iipl/crm.lead.add', {
        #   data: {'fields': fields}
        # }, function( error, response ) {
        #   if ( error ) {
        #     console.log( error );
        #   } else {
        #     console.log( response );
        #   }
        # });
        html = '<table>' + '<tr>' + '<th>NAME : </th>' + '<td>' + data.firstName + ' ' + data.lastName + '</td>' + '</tr>' + '<tr>' + '<th>EMAIL Address : </th>' + '<td>' + data.emailId + '</td>' + '</tr>' + '<tr>' + '<th>PHONE NO : </th>' + '<td>' + data.phoneNo + '</td>' + '</tr>' + '<tr>' + '<th>DATE : </th>' + '<td>' + data.date + '</td>' + '</tr>' + '</table>'
        SSR.compileTemplate 'emailText', html
        emailObj =
            to: 'info@joyful-giver.com'
            subject: 'Demo request received'
        emailObj['html'] = SSR.render('emailText')
        emailObj['from'] = 'info@joyful-giver.com'
        Email.send emailObj
        requestDemo.insert data

    'UpdateMobileNo': ->
        Meteor.users.update Meteor.userId(), $unset:
            'profile.phone_verified': null
            'profile.phone': null

    'updatePhoneVerified': -> Meteor.users.update Meteor.userId(), $set:'profile.phone_verified':true
    'updatePhoneNo': (phone) -> Meteor.users.update Meteor.userId(), $set:'profile.phone':phone
    'updateTithePlanStatus': (id, Status) -> TithePlans.update id, $set:status:Status
    'updateTithePlan': (id, amt, recur) ->
        TithePlans.update id, $set:
            amount: amt
            recurrence: recur
    'toggleUserTour': ->
        user = Meteor.user()
        if user and user.profile
            return Meteor.users.update(Meteor.userId(), $set: 'profile.tour': !user.profile.tour)
        return
    'addMyChurches': (churchId, code) ->
        MyChurches.insert
            church: churchId
            user: Meteor.userId()
            code: code
    'addTithePlan': (obj) -> TithePlans.insert obj
    'updateTithePlanObj': (id, TithePlanObj) -> TithePlans.update id, $set: TithePlanObj
    'addMyCards': (cardObj) -> MyCards.insert cardObj
    'updateTitheuserID': (id, obj) -> Tithes.update id, $set: obj
    'updateUserDetail': (data) -> Meteor.users.update Meteor.userId(), $set: data
    'select_role': (role) -> Roles.addUsersToRoles Meteor.userId(), if role == 'Organization' then 'church' else 'user'
